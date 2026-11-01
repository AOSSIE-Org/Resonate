import 'package:resonate/features/activity_status/model/call_blocked_by_activity_status.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/friends/data/friend_call_coordinator.dart';
import 'package:resonate/features/friends/data/friends.dart';
import 'package:resonate/features/friends/model/friend_rows_state.dart';
import 'package:resonate/features/friends/model/friends_model.dart';
import 'package:resonate/features/friends/model/start_call_outcome.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/friends_list_notifier.g.dart';

@riverpod
class FriendsList extends _$FriendsList {
  Set<String> _busy = const <String>{};

  @override
  FriendRowsState build() => FriendRowsState(
    rows: ref.watch(friendsProvider).whenData((s) => s.friends),
    busy: _busy,
  );
  
  String otherNameOf(FriendsModel friend) {
    final uid = ref.read(currentUserProvider)?.uid;
    return friend.senderId == uid ? friend.recieverName : friend.senderName;
  }

  Future<StartCallOutcome> startCall(FriendsModel friend) async {
    if (_busy.contains(friend.docId)) return const StartCallStarted();
    _setBusy({..._busy, friend.docId});
    try {
      await ref.read(friendCallCoordinatorProvider.notifier).startCall(friend);
      return const StartCallStarted();
    } on CallBlockedByActivityStatus catch (e) {
      return StartCallBlocked(e.status);
    } catch (e) {
      return StartCallFailed(e.toString());
    } finally {
      _setBusy({..._busy}..remove(friend.docId));
    }
  }

  void _setBusy(Set<String> next) {
    _busy = next;
    if (ref.mounted) state = state.copyWith(busy: next);
  }
}
