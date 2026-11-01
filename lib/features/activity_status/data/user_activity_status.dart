import 'dart:async';
import 'dart:developer';

import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/friends/data/friends.dart';
import 'package:resonate/features/activity_status/data/repositories/activity_status_repository.dart';
import 'package:resonate/utils/enums/activity_status.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/user_activity_status.g.dart';


@Riverpod(keepAlive: true)
class UserActivityStatus extends _$UserActivityStatus {
  final Map<String, ActivityStatus> _cache = {};
  Set<String> _tracked = const {};
  StreamSubscription<({String uid, ActivityStatus status})>? _sub;

  @override
  Map<String, ActivityStatus> build() {
    ref.onDispose(_cancelSub);

    final me = ref.watch(currentUserProvider)?.uid;
    final friends = ref.watch(friendsProvider).value;
    if (me == null || friends == null) {
      _cache.clear();
      _tracked = const {};
      return const {};
    }

    _tracked = {
      for (final friend in [...friends.friends, ...friends.friendRequests])
        friend.senderId == me ? friend.recieverId : friend.senderId,
    };
    _cache.removeWhere((uid, _) => !_tracked.contains(uid));

    _sub ??= ref
        .read(activityStatusRepositoryProvider)
        .activityStatusStream()
        .listen(_onActivityStatusEvent);

    final missing = _tracked.difference(_cache.keys.toSet());
    if (missing.isNotEmpty) unawaited(_fetch(missing));

    return Map.unmodifiable(_cache);
  }

  ActivityStatus? statusOf(String uid) => _cache[uid];

  void _onActivityStatusEvent(({String uid, ActivityStatus status}) event) {
    if (!_tracked.contains(event.uid)) return;
    final visible = event.status.asSeenByOthers;
    if (_cache[event.uid] == visible) return;

    _cache[event.uid] = visible;
    if (!ref.mounted) return;
    state = Map.unmodifiable(_cache);
  }

  Future<void> _fetch(Set<String> uids) async {
    try {
      final statuses = await ref
          .read(activityStatusRepositoryProvider)
          .loadStatuses(uids);
      if (!ref.mounted) return;

      for (final entry in statuses.entries) {
        if (!_tracked.contains(entry.key)) continue;
        _cache[entry.key] = entry.value.asSeenByOthers;
      }
      state = Map.unmodifiable(_cache);
    } catch (e) {
      log('UserActivityStatus: could not load statuses: $e');
    }
  }

  // Nulls the field before the async cancel
  Future<void> _cancelSub() async {
    final sub = _sub;
    _sub = null;
    await sub?.cancel();
  }
}
