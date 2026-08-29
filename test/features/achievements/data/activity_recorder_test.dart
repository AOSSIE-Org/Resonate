import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/achievements/data/my_stats.dart';
import 'package:resonate/features/achievements/data/repositories/achievements_repository.dart';
import 'package:resonate/features/achievements/data/services/activity_recorder.dart';
import 'package:resonate/features/achievements/model/user_stats.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/auth/model/auth_user.dart';

import '../../../helpers/test_root_container.dart';
import '../fake_achievements_repository.dart';

ProviderContainer buildContainer(
  FakeAchievementsRepository repo, {
  AuthUser? user,
}) {
  final container = ProviderContainer(
    overrides: [
      achievementsRepositoryProvider.overrideWithValue(repo),
      currentUserProvider.overrideWithValue(user ?? fakeAuthUser(uid: 'me')),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('marking the day active', () {
    testWidgets('records activity as soon as a uid is known', (tester) async {
      final repo = FakeAchievementsRepository();
      buildContainer(repo).read(activityRecorderProvider);
      await tester.pump();

      expect(repo.activityCalls, [0], reason: 'a bare day-active call');
    });

    testWidgets('does nothing while signed out', (tester) async {
      final repo = FakeAchievementsRepository();
      final container = ProviderContainer(
        overrides: [
          achievementsRepositoryProvider.overrideWithValue(repo),
          currentUserProvider.overrideWithValue(null),
        ],
      );
      addTearDown(container.dispose);

      container.read(activityRecorderProvider);
      await tester.pump();

      expect(repo.activityCalls, isEmpty);
    });

    testWidgets('folds the returned stats into MyStats', (tester) async {
      final repo = FakeAchievementsRepository()
        ..stats = const UserStats(activeDays: 4, currentStreak: 2);
      final container = buildContainer(repo);

      container.read(activityRecorderProvider);
      await tester.pump();

      expect(container.read(myStatsProvider).value?.activeDays, 4);
    });
  });

  group('interactions', () {
    testWidgets('are batched into one call', (tester) async {
      final repo = FakeAchievementsRepository();
      final container = buildContainer(repo);
      final recorder = container.read(activityRecorderProvider.notifier);
      await tester.pump();
      repo.activityCalls.clear();

      recorder
        ..recordInteraction()
        ..recordInteraction()
        ..recordInteraction();
      expect(repo.activityCalls, isEmpty, reason: 'nothing sent yet');

      await tester.pump(kInteractionFlushDelay);
      expect(repo.activityCalls, [3]);
    });

    // Must not restart per message, or steady typing would never flush.
    testWidgets('flush is not postponed by further interactions', (
      tester,
    ) async {
      final repo = FakeAchievementsRepository();
      final container = buildContainer(repo);
      final recorder = container.read(activityRecorderProvider.notifier);
      await tester.pump();
      repo.activityCalls.clear();

      recorder.recordInteraction();
      await tester.pump(kInteractionFlushDelay ~/ 2);
      recorder.recordInteraction();
      await tester.pump(kInteractionFlushDelay ~/ 2);

      expect(repo.activityCalls, [2]);
    });

    testWidgets('a second batch starts a fresh timer', (tester) async {
      final repo = FakeAchievementsRepository();
      final container = buildContainer(repo);
      final recorder = container.read(activityRecorderProvider.notifier);
      await tester.pump();
      repo.activityCalls.clear();

      recorder.recordInteraction(2);
      await tester.pump(kInteractionFlushDelay);
      recorder.recordInteraction(5);
      await tester.pump(kInteractionFlushDelay);

      expect(repo.activityCalls, [2, 5]);
    });

    testWidgets('ignores non-positive counts', (tester) async {
      final repo = FakeAchievementsRepository();
      final container = buildContainer(repo);
      final recorder = container.read(activityRecorderProvider.notifier);
      await tester.pump();
      repo.activityCalls.clear();

      recorder
        ..recordInteraction(0)
        ..recordInteraction(-4);
      await tester.pump(kInteractionFlushDelay);

      expect(repo.activityCalls, isEmpty);
    });
  });

  group('room credit', () {
    testWidgets('asks the server once per room', (tester) async {
      final repo = FakeAchievementsRepository();
      final container = buildContainer(repo);
      final recorder = container.read(activityRecorderProvider.notifier);
      await tester.pump();

      await recorder.recordRoomCredit('room-1');
      await recorder.recordRoomCredit('room-1');
      await recorder.recordRoomCredit('room-2');

      expect(repo.roomCredits, ['room-1', 'room-2']);
    });

    testWidgets('does nothing while signed out', (tester) async {
      final repo = FakeAchievementsRepository();
      final container = ProviderContainer(
        overrides: [
          achievementsRepositoryProvider.overrideWithValue(repo),
          currentUserProvider.overrideWithValue(null),
        ],
      );
      addTearDown(container.dispose);
      final recorder = container.read(activityRecorderProvider.notifier);
      await tester.pump();

      await recorder.recordRoomCredit('room-1');

      expect(repo.roomCredits, isEmpty);
    });
  });

  group('failures', () {
    // A user mid-chat can do nothing about a failed counter.
    testWidgets('a failing call does not escape the recorder', (tester) async {
      final repo = FakeAchievementsRepository()
        ..recordError = Exception('offline');
      final container = buildContainer(repo);
      final recorder = container.read(activityRecorderProvider.notifier);
      await tester.pump();

      await expectLater(recorder.recordRoomCredit('room-1'), completes);
    });
  });

  group('badgesEarned', () {
    testWidgets('emits what the server says was just earned', (tester) async {
      final repo = FakeAchievementsRepository()..nextNewBadges = ['icon'];
      final container = buildContainer(repo);
      final emitted = <List<String>>[];
      container
          .read(activityRecorderProvider.notifier)
          .badgesEarned
          .listen(emitted.add);

      await tester.pump();
      await tester.pump();

      expect(emitted, [
        ['icon'],
      ]);
    });

    testWidgets('stays quiet when nothing new was earned', (tester) async {
      final repo = FakeAchievementsRepository();
      final container = buildContainer(repo);
      final emitted = <List<String>>[];
      container
          .read(activityRecorderProvider.notifier)
          .badgesEarned
          .listen(emitted.add);

      await tester.pump();
      await tester.pump();

      expect(emitted, isEmpty);
    });
  });
}
