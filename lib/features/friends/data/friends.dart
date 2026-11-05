import 'dart:async';
import 'package:resonate/utils/dev_log.dart';

import 'package:appwrite/appwrite.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/friends/data/repositories/friends_repository.dart';
import 'package:resonate/features/friends/model/friends_model.dart';
import 'package:resonate/features/friends/model/friends_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/friends.g.dart';

// Data-layer cache of the user's friends + incoming requests
@Riverpod(keepAlive: true)
class FriendsNotifier extends _$FriendsNotifier {
  StreamSubscription<RealtimeMessage>? _friendsSub;

  final Set<String> _requestsInFlight = <String>{};
  final Set<String> _acceptsInFlight = <String>{};

  @override
  Future<FriendsState> build() async {
    ref.onDispose(_cancelSub);
    final uid = ref.watch(currentUserProvider)?.uid;
    if (uid == null) return const FriendsState();

    final repo = ref.watch(friendsRepositoryProvider);
    final lists = await repo.loadFriends(uid);

    await _cancelSub();
    _friendsSub = repo.friendsStream(uid).listen((_) => _refreshQuietly());

    return FriendsState(friends: lists.friends, friendRequests: lists.requests);
  }

  Future<void> sendFriendRequest({
    required String recieverId,
    required String recieverProfileImageUrl,
    required String recieverUsername,
    required String recieverName,
    required double recieverRating,
  }) async {
    if (!_requestsInFlight.add(recieverId)) return;
    try {
      if (state.value?.relationWith(recieverId) != null) return;

      final model = await ref.read(friendsRepositoryProvider).sendFriendRequest(
        sender: ref.read(requireUserProvider),
        recieverId: recieverId,
        recieverProfileImageUrl: recieverProfileImageUrl,
        recieverUsername: recieverUsername,
        recieverName: recieverName,
        recieverRating: recieverRating,
      );

      final current = state.value;
      if (current == null || !ref.mounted) return;
      state = AsyncData(
        current.copyWith(friendRequests: [...current.friendRequests, model]),
      );
    } finally {
      _requestsInFlight.remove(recieverId);
    }
  }

  Future<void> acceptFriendRequest(FriendsModel friendModel) async {
    if (!_acceptsInFlight.add(friendModel.docId)) return;
    try {
      final updated = await ref
          .read(friendsRepositoryProvider)
          .acceptFriendRequest(friendModel);

      final current = state.value;
      if (current == null || !ref.mounted) return;
      state = AsyncData(
        current.copyWith(
          // Replaced rather than appended, so a realtime refresh that already
          // carried this row does not leave a second copy behind.
          friends: [
            ...current.friends.where((f) => f.docId != updated.docId),
            updated,
          ],
          friendRequests: current.friendRequests
              .where((request) => request.docId != friendModel.docId)
              .toList(),
        ),
      );
    } finally {
      _acceptsInFlight.remove(friendModel.docId);
    }
  }

  Future<void> declineFriendRequest(FriendsModel friendModel) async {
    await ref.read(friendsRepositoryProvider).deleteFriendRow(friendModel.docId);

    final current = state.value;
    if (current == null || !ref.mounted) return;
    state = AsyncData(
      current.copyWith(
        friendRequests: current.friendRequests
            .where((request) => request.docId != friendModel.docId)
            .toList(),
      ),
    );
  }

  Future<void> removeFriend(FriendsModel friendModel) async {
    await ref.read(friendsRepositoryProvider).deleteFriendRow(friendModel.docId);

    final current = state.value;
    if (current == null || !ref.mounted) return;
    state = AsyncData(
      current.copyWith(
        friends: current.friends
            .where((friend) => friend.docId != friendModel.docId)
            .toList(),
        friendRequests: current.friendRequests
            .where((request) => request.docId != friendModel.docId)
            .toList(),
      ),
    );
  }

  // Realtime sync
  Future<void> _refreshQuietly() async {
    try {
      final uid = ref.read(requireUserProvider).uid;
      final lists = await ref.read(friendsRepositoryProvider).loadFriends(uid);
      if (!ref.mounted) return;
      state = AsyncData(
        FriendsState(friends: lists.friends, friendRequests: lists.requests),
      );
    } catch (e) {
      log('Friends realtime refresh failed: $e');
    }
  }

  // Nulls the field before the async cancel
  Future<void> _cancelSub() async {
    final sub = _friendsSub;
    _friendsSub = null;
    await sub?.cancel();
  }
}
