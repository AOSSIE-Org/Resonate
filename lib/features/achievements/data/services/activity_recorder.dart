import 'dart:async';
import 'dart:developer';

import 'package:resonate/features/achievements/data/my_stats.dart';
import 'package:resonate/features/achievements/data/repositories/achievements_repository.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/activity_recorder.g.dart';

const Duration kInteractionFlushDelay = Duration(seconds: 10);

const int kCreditWorthyParticipants = 6;

@Riverpod(keepAlive: true)
class ActivityRecorder extends _$ActivityRecorder {
  final StreamController<List<String>> _earned =
      StreamController<List<String>>.broadcast();

  String? _uid;
  int _pendingInteractions = 0;
  Timer? _flushTimer;
  bool _markedActive = false;
  final Set<String> _creditedRooms = {};

  @override
  void build() {
    ref.onDispose(_dispose);

    final uid = ref.watch(currentUserProvider)?.uid;
    if (uid != _uid) {
      _uid = uid;
      _markedActive = false;
      _creditedRooms.clear();
    }
    if (uid == null || _markedActive) return;

    _markedActive = true;
    unawaited(_send(() => _repository.recordActivity()));
  }

  Stream<List<String>> get badgesEarned => _earned.stream;

  void recordInteraction([int count = 1]) {
    if (_uid == null || count <= 0) return;
    _pendingInteractions += count;
    _flushTimer ??= Timer(kInteractionFlushDelay, _flushInteractions);
  }

  Future<void> recordRoomCredit(String roomId) async {
    if (_uid == null || !_creditedRooms.add(roomId)) return;
    await _send(() => _repository.recordRoomCredit(roomId));
  }

  AchievementsRepository get _repository =>
      ref.read(achievementsRepositoryProvider);

  void _flushInteractions() {
    _flushTimer = null;
    final pending = _pendingInteractions;
    _pendingInteractions = 0;
    if (pending <= 0 || _uid == null) return;
    unawaited(_send(() => _repository.recordActivity(interactions: pending)));
  }

  Future<void> _send(Future<ActivityResult> Function() call) async {
    try {
      final result = await call();
      if (!ref.mounted) return;
      ref.read(myStatsProvider.notifier).apply(result.stats);
      if (result.newBadges.isNotEmpty && !_earned.isClosed) {
        _earned.add(result.newBadges);
      }
    } catch (e) {
      log('ActivityRecorder: could not record activity: $e');
    }
  }

  void _dispose() {
    _flushTimer?.cancel();
    _flushTimer = null;
    unawaited(_earned.close());
  }
}
