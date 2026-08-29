import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/achievements/data/badge_catalogue.dart';
import 'package:resonate/features/achievements/data/repositories/achievements_repository.dart';
import 'package:resonate/features/achievements/model/achievement_badge.dart';
import 'package:resonate/features/achievements/model/badge_category.dart';

import '../fake_achievements_repository.dart';

ProviderContainer containerWith(FakeAchievementsRepository repo) {
  final container = ProviderContainer(
    overrides: [achievementsRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(container.dispose);
  return container;
}

AchievementBadge badge(
  String id,
  BadgeCategory category,
  BadgeMetric metric,
  int threshold,
  int tier,
) => AchievementBadge(
  id: id,
  category: category,
  metric: metric,
  threshold: threshold,
  tier: tier,
);

void main() {
  test('badgeCatalogue serves what the repository loaded', () async {
    final repo = FakeAchievementsRepository()
      ..catalogue = [
        badge('welcomer', BadgeCategory.hosting, BadgeMetric.roomsHosted, 3, 1),
      ];

    final catalogue = await containerWith(
      repo,
    ).read(badgeCatalogueProvider.future);

    expect(
      catalogue.single.threshold,
      3,
      reason: 'the tuned threshold, not 10',
    );
    expect(repo.loadCatalogueCount, 1);
  });

  group('badgeLadders', () {
    test('groups by category with tiers in ascending order', () async {
      final repo = FakeAchievementsRepository()
        ..catalogue = [
          badge(
            'maestro',
            BadgeCategory.hosting,
            BadgeMetric.roomsHosted,
            50,
            3,
          ),
          badge(
            'welcomer',
            BadgeCategory.hosting,
            BadgeMetric.roomsHosted,
            10,
            1,
          ),
          badge('icon', BadgeCategory.hosting, BadgeMetric.roomsHosted, 25, 2),
          badge(
            'guard',
            BadgeCategory.moderation,
            BadgeMetric.roomsModerated,
            10,
            1,
          ),
        ];

      final ladders = await containerWith(
        repo,
      ).read(badgeLaddersProvider.future);

      expect(ladders.keys, [BadgeCategory.hosting, BadgeCategory.moderation]);
      expect(ladders[BadgeCategory.hosting]!.map((b) => b.id), [
        'welcomer',
        'icon',
        'maestro',
      ]);
    });

    // Rows arrive in Appwrite's order; the UI must not reshuffle because of it.
    test(
      'categories come out in enum order whatever order the rows arrive in',
      () async {
        final repo = FakeAchievementsRepository()
          ..catalogue = [
            badge('core', BadgeCategory.core, BadgeMetric.activeDays, 30, 1),
            badge('echo', BadgeCategory.echo, BadgeMetric.interactions, 50, 1),
            badge(
              'welcomer',
              BadgeCategory.hosting,
              BadgeMetric.roomsHosted,
              10,
              1,
            ),
          ];

        final ladders = await containerWith(
          repo,
        ).read(badgeLaddersProvider.future);

        expect(ladders.keys, [
          BadgeCategory.hosting,
          BadgeCategory.echo,
          BadgeCategory.core,
        ]);
      },
    );

    test('the built-in catalogue produces five ladders', () async {
      final ladders = await containerWith(
        FakeAchievementsRepository(),
      ).read(badgeLaddersProvider.future);

      expect(ladders.keys, BadgeCategory.values);
      expect(ladders[BadgeCategory.hosting], hasLength(3));
      expect(ladders[BadgeCategory.moderation], hasLength(3));
      expect(ladders[BadgeCategory.echo], hasLength(1));
    });

    test('an empty catalogue yields no ladders rather than throwing', () async {
      final repo = FakeAchievementsRepository()..catalogue = const [];

      final ladders = await containerWith(
        repo,
      ).read(badgeLaddersProvider.future);

      expect(ladders, isEmpty);
    });
  });
}
