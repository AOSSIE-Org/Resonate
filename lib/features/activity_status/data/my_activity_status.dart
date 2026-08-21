import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:resonate/core/providers/app_lifecycle_provider.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/activity_status/data/repositories/activity_status_repository.dart';
import 'package:resonate/features/live_audio/data/services/livekit_controller.dart';
import 'package:resonate/utils/enums/activity_status.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/my_activity_status.g.dart';

@Riverpod(keepAlive: true)
class MyActivityStatus extends _$MyActivityStatus {
  ActivityStatus _chosen = ActivityStatus.online;
  bool _inSession = false;
  bool _isAway = false;
  String? _uid;
  ActivityStatus? _lastWritten;
  bool _hydrateStarted = false;
  bool _hydrated = false;
  bool _userPicked = false;

  @override
  ActivityStatus build() {
    final uid = ref.watch(currentUserProvider)?.uid;
    _inSession = ref.watch(liveKitControllerProvider).hasSession;
    final lifecycle = ref.watch(appLifecycleProvider);
    _isAway =
        lifecycle == AppLifecycleState.paused ||
        lifecycle == AppLifecycleState.hidden;

    if (uid != _uid) {
      _uid = uid;
      _chosen = ActivityStatus.online;
      _lastWritten = null;
      _hydrateStarted = false;
      _hydrated = false;
      _userPicked = false;
    }

    if (uid == null) return ActivityStatus.offline;

    if (!_hydrateStarted) {
      _hydrateStarted = true;
      unawaited(_hydrate(uid));
    }

    final effective = _effective;
    if (_hydrated) unawaited(_write(uid, effective));
    return effective;
  }

  ActivityStatus get chosen => _chosen;

  ActivityStatus get _effective {
    if (_uid == null) return ActivityStatus.offline;
    if (_inSession) return ActivityStatus.inRoom;
    if (_isAway && _chosen == ActivityStatus.online) {
      return ActivityStatus.offline;
    }
    return _chosen;
  }

  // Applies a status the user picked themselves.
  Future<void> setStatus(ActivityStatus status) async {
    assert(
      ActivityStatus.selectable.contains(status),
      '$status is system-driven and cannot be picked by the user',
    );
    final uid = _uid;
    if (uid == null) return;

    _chosen = status;
    _userPicked = true;
    final effective = _effective;
    if (ref.mounted) state = effective;
    await _write(uid, effective);
  }

  Future<void> goOffline() async {
    final uid = _uid;
    if (uid == null) return;
    await _write(uid, ActivityStatus.offline);
  }

  Future<void> _hydrate(String uid) async {
    ActivityStatus? stored;
    try {
      stored = await ref.read(activityStatusRepositoryProvider).loadStatus(uid);
    } catch (e) {
      log('MyActivityStatus: could not read the stored status: $e');
    }
    if (!ref.mounted || _uid != uid) return;

    if (stored != null && !_userPicked) {
      _chosen = ActivityStatus.selectable.contains(stored)
          ? stored
          : ActivityStatus.online;
    }

    _hydrated = true;
    final effective = _effective;
    state = effective;
    await _write(uid, effective);
  }

  Future<void> _write(String uid, ActivityStatus status) async {
    if (_lastWritten == status) return;
    _lastWritten = status;
    try {
      await ref
          .read(activityStatusRepositoryProvider)
          .setStatus(uid: uid, status: status);
    } catch (e) {
      _lastWritten = null;
      log('MyActivityStatus: could not write status ${status.wire}: $e');
    }
  }
}
