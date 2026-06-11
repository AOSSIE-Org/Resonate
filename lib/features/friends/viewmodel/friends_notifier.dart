import 'dart:async';
import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:resonate/core/container.dart';
import 'package:resonate/features/auth/viewmodel/auth_notifier.dart';
import 'package:resonate/features/friends/data/friends_repository.dart';
import 'package:resonate/features/friends/model/friends_model.dart';
import 'package:resonate/features/friends/model/friends_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/friends_notifier.g.dart';

@Riverpod(keepAlive: true)
class FriendsNotifier extends _$FriendsNotifier {
  StreamSubscription<RealtimeMessage>? _friendsSub;

  @override
  Future<FriendsState> build() async {
    ref.onDispose(_cancelSub);
    final uid = ref.watch(authProvider).value?.userOrNull?.uid;
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
    final model = await ref.read(friendsRepositoryProvider).sendFriendRequest(
      sender: requireCurrentAuthUser,
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
  }

  Future<void> acceptFriendRequest(FriendsModel friendModel) async {
    final updated = await ref
        .read(friendsRepositoryProvider)
        .acceptFriendRequest(friendModel);

    final current = state.value;
    if (current == null || !ref.mounted) return;
    state = AsyncData(
      current.copyWith(
        friends: [...current.friends, updated],
        friendRequests: current.friendRequests
            .where((request) => request.docId != friendModel.docId)
            .toList(),
      ),
    );
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
      final uid = requireCurrentAuthUser.uid;
      final lists = await ref.read(friendsRepositoryProvider).loadFriends(uid);
      if (!ref.mounted) return;
      state = AsyncData(
        FriendsState(friends: lists.friends, friendRequests: lists.requests),
      );
    } catch (e) {
      log('Friends realtime refresh failed: $e');
    }
  }

  // Nulls the field BEFORE the async cancel so concurrent callers (rebuild
  // racing an un-awaited dispose) never see a half-cancelled subscription.
  Future<void> _cancelSub() async {
    final sub = _friendsSub;
    _friendsSub = null;
    await sub?.cancel();
  }
}
