import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/achievements/data/my_stats.dart';
import 'package:resonate/features/achievements/data/repositories/achievements_repository.dart';
import 'package:resonate/features/achievements/model/user_stats.dart';
import 'package:resonate/features/auth/data/current_user.dart';

import '../../../helpers/test_root_container.dart';
import '../fake_achievements_repository.dart';

ProviderContainer buildContainer(
  FakeAchievementsRepository repo, {
  bool signedOut = false,
}) {
  final container = ProviderContainer(
    overrides: [
      achievementsRepositoryProvider.overrideWithValue(repo),
      currentUserProvider.overrideWithValue(
        signedOut ? null : fakeAuthUser(uid: 'me'),
      ),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('loads the signed-in user\'s row', () async {
    final repo = FakeAchievementsRepository()
      ..stats = const UserStats(roomsHosted: 3);

    final stats = await buildContainer(repo).read(myStatsProvider.future);

    expect(stats.roomsHosted, 3);
    expect(repo.loadedUids, ['me']);
  });

  test('is empty while signed out, without touching the repository', () async {
    final repo = FakeAchievementsRepository();

    final stats = await buildContainer(
      repo,
      signedOut: true,
    ).read(myStatsProvider.future);

    expect(stats, UserStats.empty);
    expect(repo.loadedUids, isEmpty);
  });

  group('setShowcase', () {
    test('sends the pick and folds the result back in', () async {
      final repo = FakeAchievementsRepository()
        ..stats = const UserStats(badges: ['echo', 'maestro']);
      final container = buildContainer(repo);
      await container.read(myStatsProvider.future);

      final saved = await container
          .read(myStatsProvider.notifier)
          .setShowcase(displayedBadges: ['echo'], avatarBadge: 'maestro');

      expect(saved, isTrue);
      expect(repo.showcaseCalls.single.displayedBadges, ['echo']);
      expect(repo.showcaseCalls.single.avatarBadge, 'maestro');
      expect(container.read(myStatsProvider).value?.displayedBadges, ['echo']);
      expect(container.read(myStatsProvider).value?.avatarBadge, 'maestro');
    });

    test('clears the avatar badge when passed null', () async {
      final repo = FakeAchievementsRepository()
        ..stats = const UserStats(badges: ['echo'], avatarBadge: 'echo');
      final container = buildContainer(repo);
      await container.read(myStatsProvider.future);

      await container
          .read(myStatsProvider.notifier)
          .setShowcase(displayedBadges: const [], avatarBadge: null);

      expect(container.read(myStatsProvider).value?.avatarBadge, isNull);
    });

    // The sheet turns a false into a snackbar; it must never see an exception.
    test('reports a refusal as false rather than throwing', () async {
      final repo = FakeAchievementsRepository()
        ..recordError = Exception('not earned');
      final container = buildContainer(repo);
      await container.read(myStatsProvider.future);

      final saved = await container
          .read(myStatsProvider.notifier)
          .setShowcase(displayedBadges: ['maestro'], avatarBadge: null);

      expect(saved, isFalse);
    });
  });

  test('apply replaces the cached stats', () async {
    final container = buildContainer(FakeAchievementsRepository());
    await container.read(myStatsProvider.future);

    container
        .read(myStatsProvider.notifier)
        .apply(const UserStats(interactions: 42));

    expect(container.read(myStatsProvider).value?.interactions, 42);
  });
}
