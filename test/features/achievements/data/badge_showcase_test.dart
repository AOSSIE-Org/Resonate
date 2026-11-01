import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/achievements/data/badge_showcase.dart';
import 'package:resonate/features/achievements/data/my_stats.dart';
import 'package:resonate/features/achievements/data/repositories/achievements_repository.dart';
import 'package:resonate/features/achievements/data/user_stats_provider.dart';
import 'package:resonate/features/achievements/model/known_badge.dart';
import 'package:resonate/features/achievements/model/user_stats.dart';
import 'package:resonate/features/auth/data/current_user.dart';

import '../../../helpers/test_root_container.dart';
import '../fake_achievements_repository.dart';

ProviderContainer buildContainer({
  UserStats mine = UserStats.empty,
  Map<String, UserStats> others = const {},
}) {
  final container = ProviderContainer(
    overrides: [
      achievementsRepositoryProvider.overrideWithValue(
        FakeAchievementsRepository()..statsByUid = others,
      ),
      currentUserProvider.overrideWithValue(fakeAuthUser(uid: 'me')),
      myStatsProvider.overrideWith(() => FakeMyStats(mine)),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('statsOf', () {
    // The by-uid cache would show the signed-in user stale numbers.
    testWidgets('reads the signed-in user from MyStats', (tester) async {
      final container = buildContainer(
        mine: const UserStats(roomsHosted: 12),
        others: const {'me': UserStats(roomsHosted: 99)},
      );
      await container.read(myStatsProvider.future);

      expect(container.read(statsOfProvider('me'))?.roomsHosted, 12);
    });

    testWidgets('reads anyone else from the by-uid cache', (tester) async {
      final container = buildContainer(
        others: const {'other': UserStats(roomsHosted: 7)},
      );
      await container.read(userStatsProvider('other').future);

      expect(container.read(statsOfProvider('other'))?.roomsHosted, 7);
    });

    test('is null until the stats have loaded', () {
      expect(buildContainer().read(statsOfProvider('other')), isNull);
    });
  });

  group('avatarBadge', () {
    testWidgets('resolves the worn badge', (tester) async {
      final container = buildContainer(
        mine: const UserStats(badges: ['maestro'], avatarBadge: 'maestro'),
      );
      await container.read(myStatsProvider.future);

      expect(container.read(avatarBadgeProvider('me')), KnownBadge.maestro);
    });

    testWidgets('is null when no badge is worn', (tester) async {
      final container = buildContainer(mine: const UserStats(badges: ['echo']));
      await container.read(myStatsProvider.future);

      expect(container.read(avatarBadgeProvider('me')), isNull);
    });

    // A badge the server knows about but this build has no artwork for.
    testWidgets('is null for an unrecognised badge id', (tester) async {
      final container = buildContainer(
        mine: const UserStats(
          badges: ['trailblazer'],
          avatarBadge: 'trailblazer',
        ),
      );
      await container.read(myStatsProvider.future);

      expect(container.read(avatarBadgeProvider('me')), isNull);
    });
  });

  group('displayedBadges', () {
    testWidgets('resolves the chosen pills', (tester) async {
      final container = buildContainer(
        mine: const UserStats(
          badges: ['maestro', 'echo'],
          displayedBadges: ['echo', 'maestro'],
        ),
      );
      await container.read(myStatsProvider.future);

      // Catalogue order, not pick order, so the pills do not reshuffle.
      expect(container.read(displayedBadgesProvider('me')), [
        KnownBadge.maestro,
        KnownBadge.echo,
      ]);
    });

    testWidgets('drops ids this build cannot draw', (tester) async {
      final container = buildContainer(
        mine: const UserStats(
          badges: ['echo', 'trailblazer'],
          displayedBadges: ['trailblazer', 'echo'],
        ),
      );
      await container.read(myStatsProvider.future);

      expect(container.read(displayedBadgesProvider('me')), [KnownBadge.echo]);
    });

    testWidgets('is empty when nothing is displayed', (tester) async {
      final container = buildContainer(mine: const UserStats(badges: ['echo']));
      await container.read(myStatsProvider.future);

      expect(container.read(displayedBadgesProvider('me')), isEmpty);
    });
  });
}
