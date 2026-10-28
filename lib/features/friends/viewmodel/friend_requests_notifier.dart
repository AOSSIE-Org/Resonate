import 'package:resonate/utils/dev_log.dart';

import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/friends/data/friends.dart';
import 'package:resonate/features/friends/model/friend_rows_state.dart';
import 'package:resonate/features/friends/model/friends_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/friend_requests_notifier.g.dart';

@riverpod
class FriendRequests extends _$FriendRequests {
  Set<String> _busy = const <String>{};
  @override
  FriendRowsState build() {
    final uid = ref.watch(currentUserProvider)?.uid;
    return FriendRowsState(
      rows: ref
          .watch(friendsProvider)
          .whenData(
            (s) => s.friendRequests
                .where((friend) => friend.requestSentByUserId != uid)
                .toList(),
          ),
      busy: _busy,
    );
  }

  Future<bool> accept(FriendsModel friend) => _run(
    friend,
    () => ref.read(friendsProvider.notifier).acceptFriendRequest(friend),
  );

  Future<bool> decline(FriendsModel friend) => _run(
    friend,
    () => ref.read(friendsProvider.notifier).declineFriendRequest(friend),
  );

  Future<bool> _run(FriendsModel friend, Future<void> Function() action) async {
    if (_busy.contains(friend.docId)) return false;
    _setBusy({..._busy, friend.docId});
    try {
      await action();
      return true;
    } catch (e) {
      log('FriendRequests: the action on ${friend.docId} failed: $e');
      return false;
    } finally {
      _setBusy({..._busy}..remove(friend.docId));
    }
  }

  void _setBusy(Set<String> next) {
    _busy = next;
    if (ref.mounted) state = state.copyWith(busy: next);
  }
}
