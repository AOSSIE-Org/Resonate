import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/achievements/model/badge_category.dart';
import 'package:resonate/features/achievements/model/user_stats.dart';

void main() {
  group('UserStats.fromMap', () {
    test('reads a full row', () {
      final stats = UserStats.fromMap(const {
        'roomsHosted': 12,
        'roomsModerated': 3,
        'interactions': 84,
        'activeDays': 22,
        'currentStreak': 5,
        'longestStreak': 9,
        'badges': ['welcomer', 'echo'],
        'displayedBadges': ['welcomer'],
        'avatarBadge': 'echo',
      });

      expect(stats.roomsHosted, 12);
      expect(stats.roomsModerated, 3);
      expect(stats.interactions, 84);
      expect(stats.activeDays, 22);
      expect(stats.currentStreak, 5);
      expect(stats.longestStreak, 9);
      expect(stats.badges, ['welcomer', 'echo']);
      expect(stats.displayedBadges, ['welcomer']);
      expect(stats.avatarBadge, 'echo');
    });

    // A just-created row has nulls in every optional column.
    test('reads a freshly created row as all zeroes', () {
      final stats = UserStats.fromMap(const {
        'roomsHosted': null,
        'badges': null,
        'avatarBadge': null,
      });

      expect(stats, UserStats.empty);
    });

    test('reads an empty map as all zeroes', () {
      expect(UserStats.fromMap(const {}), UserStats.empty);
    });

    test('tolerates numbers arriving as doubles or strings', () {
      final stats = UserStats.fromMap(const {
        'roomsHosted': 7.0,
        'interactions': '19',
        'activeDays': 'not a number',
      });

      expect(stats.roomsHosted, 7);
      expect(stats.interactions, 19);
      expect(stats.activeDays, 0);
    });

    test('drops non-string entries from the badge lists', () {
      final stats = UserStats.fromMap(const {
        'badges': ['welcomer', 3, null],
        'displayedBadges': 'not a list',
      });

      expect(stats.badges, ['welcomer']);
      expect(stats.displayedBadges, isEmpty);
    });
  });

  group('valueOf', () {
    const stats = UserStats(
      roomsHosted: 1,
      roomsModerated: 2,
      interactions: 3,
      currentStreak: 4,
      longestStreak: 5,
      activeDays: 6,
    );

    test('returns the counter each metric names', () {
      expect(stats.valueOf(BadgeMetric.roomsHosted), 1);
      expect(stats.valueOf(BadgeMetric.roomsModerated), 2);
      expect(stats.valueOf(BadgeMetric.interactions), 3);
      expect(stats.valueOf(BadgeMetric.currentStreak), 4);
      expect(stats.valueOf(BadgeMetric.longestStreak), 5);
      expect(stats.valueOf(BadgeMetric.activeDays), 6);
    });

    test('covers every metric', () {
      for (final metric in BadgeMetric.values) {
        expect(stats.valueOf(metric), isNonNegative);
      }
    });
  });

  group('isEmpty', () {
    test('is true for a user who has done nothing', () {
      expect(UserStats.empty.isEmpty, isTrue);
    });

    test('is false once any counter has moved', () {
      expect(const UserStats(roomsHosted: 1).isEmpty, isFalse);
      expect(const UserStats(roomsModerated: 1).isEmpty, isFalse);
      expect(const UserStats(interactions: 1).isEmpty, isFalse);
      expect(const UserStats(activeDays: 1).isEmpty, isFalse);
      expect(const UserStats(badges: ['echo']).isEmpty, isFalse);
    });

    // A streak cannot exist without an active day, so it is not part of the check.
    test('a bare streak does not count as activity', () {
      expect(const UserStats(currentStreak: 3).isEmpty, isTrue);
    });
  });

  test('hasEarned reflects the badge list', () {
    const stats = UserStats(badges: ['welcomer', 'guard']);
    expect(stats.hasEarned('welcomer'), isTrue);
    expect(stats.hasEarned('maestro'), isFalse);
  });
}
