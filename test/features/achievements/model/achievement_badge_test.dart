import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/achievements/model/achievement_badge.dart';
import 'package:resonate/features/achievements/model/badge_category.dart';
import 'package:resonate/features/achievements/model/known_badge.dart';

void main() {
  group('AchievementBadge.fromMap', () {
    test('reads a threshold row', () {
      final badge = AchievementBadge.fromMap(const {
        'badgeId': 'icon',
        'category': 'hosting',
        'metric': 'roomsHosted',
        'threshold': 25,
        'tier': 2,
      });

      expect(badge, isNotNull);
      expect(badge!.id, 'icon');
      expect(badge.category, BadgeCategory.hosting);
      expect(badge.metric, BadgeMetric.roomsHosted);
      expect(badge.threshold, 25);
      expect(badge.tier, 2);
    });

    test('defaults a missing tier to the first', () {
      final badge = AchievementBadge.fromMap(const {
        'badgeId': 'echo',
        'category': 'echo',
        'metric': 'interactions',
        'threshold': 50,
      });

      expect(badge?.tier, 1);
    });

    // One malformed row must not take out the whole catalogue.
    test('returns null for a row it cannot make sense of', () {
      for (final row in <Map<String, dynamic>>[
        {},
        {
          'badgeId': '',
          'category': 'hosting',
          'metric': 'roomsHosted',
          'threshold': 1,
        },
        {
          'badgeId': 'x',
          'category': 'nonsense',
          'metric': 'roomsHosted',
          'threshold': 1,
        },
        {
          'badgeId': 'x',
          'category': 'hosting',
          'metric': 'nonsense',
          'threshold': 1,
        },
        {'badgeId': 'x', 'category': 'hosting', 'metric': 'roomsHosted'},
        {
          'badgeId': 'x',
          'category': 'hosting',
          'metric': 'roomsHosted',
          'threshold': 'ten',
        },
      ]) {
        expect(AchievementBadge.fromMap(row), isNull, reason: '$row');
      }
    });
  });

  group('the built-in catalogue', () {
    // Mirrors DEFAULT_BADGES in the backend; both sides must agree.
    test('matches the catalogue the backend seeds', () {
      expect(
        kDefaultBadges.map(
          (b) =>
              '${b.id}:${b.category.wire}:${b.metric.wire}:${b.threshold}:${b.tier}',
        ),
        [
          'welcomer:hosting:roomsHosted:10:1',
          'icon:hosting:roomsHosted:25:2',
          'maestro:hosting:roomsHosted:50:3',
          'guard:moderation:roomsModerated:10:1',
          'sentinel:moderation:roomsModerated:25:2',
          'warden:moderation:roomsModerated:50:3',
          'echo:echo:interactions:50:1',
          'rhythm:rhythm:longestStreak:7:1',
          'core:core:activeDays:30:1',
        ],
      );
    });

    test('every badge is one this build can draw and name', () {
      for (final badge in kDefaultBadges) {
        final known = KnownBadge.fromId(badge.id);
        expect(known, isNotNull, reason: 'no KnownBadge for ${badge.id}');
        expect(known!.category, badge.category);
      }
    });

    test('covers every category', () {
      expect(
        kDefaultBadges.map((b) => b.category).toSet(),
        BadgeCategory.values.toSet(),
      );
    });

    // Only a monotonic counter can back a badge that is never revoked.
    test('no badge is measured against a counter that can go down', () {
      expect(
        kDefaultBadges.any((b) => b.metric == BadgeMetric.currentStreak),
        isFalse,
      );
    });

    test('tiers within a category rise together', () {
      for (final category in BadgeCategory.values) {
        final tiers = kDefaultBadges
            .where((b) => b.category == category)
            .toList();
        for (var i = 1; i < tiers.length; i++) {
          expect(tiers[i].threshold, greaterThan(tiers[i - 1].threshold));
          expect(tiers[i].tier, greaterThan(tiers[i - 1].tier));
        }
        // A category measures one thing, so its ladder shares one metric.
        expect(tiers.map((b) => b.metric).toSet(), hasLength(1));
      }
    });
  });

  group('KnownBadge', () {
    test('ids round-trip', () {
      for (final badge in KnownBadge.values) {
        expect(KnownBadge.fromId(badge.id), badge);
      }
    });

    test('is null for an id this build does not know', () {
      expect(KnownBadge.fromId(null), isNull);
      expect(KnownBadge.fromId(''), isNull);
      expect(KnownBadge.fromId('trailblazer'), isNull);
    });
  });
}
