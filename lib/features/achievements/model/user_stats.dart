import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:resonate/features/achievements/model/badge_category.dart';

part 'generated/user_stats.freezed.dart';

@freezed
abstract class UserStats with _$UserStats {
  const factory UserStats({
    @Default(0) int roomsHosted,
    @Default(0) int roomsModerated,
    @Default(0) int interactions,
    @Default(0) int activeDays,
    @Default(0) int currentStreak,
    @Default(0) int longestStreak,
    @Default(<String>[]) List<String> badges,
    @Default(<String>[]) List<String> displayedBadges,
    String? avatarBadge,
  }) = _UserStats;

  const UserStats._();

  // Appwrite returns null for every column the function has not written yet.
  factory UserStats.fromMap(Map<String, dynamic> data) => UserStats(
    roomsHosted: _int(data['roomsHosted']),
    roomsModerated: _int(data['roomsModerated']),
    interactions: _int(data['interactions']),
    activeDays: _int(data['activeDays']),
    currentStreak: _int(data['currentStreak']),
    longestStreak: _int(data['longestStreak']),
    badges: _strings(data['badges']),
    displayedBadges: _strings(data['displayedBadges']),
    avatarBadge: data['avatarBadge'] as String?,
  );

  static const empty = UserStats();

  int valueOf(BadgeMetric metric) => switch (metric) {
    BadgeMetric.roomsHosted => roomsHosted,
    BadgeMetric.roomsModerated => roomsModerated,
    BadgeMetric.interactions => interactions,
    BadgeMetric.currentStreak => currentStreak,
    BadgeMetric.longestStreak => longestStreak,
    BadgeMetric.activeDays => activeDays,
  };

  bool hasEarned(String badgeId) => badges.contains(badgeId);

  bool get isEmpty =>
      roomsHosted == 0 &&
      roomsModerated == 0 &&
      interactions == 0 &&
      activeDays == 0 &&
      badges.isEmpty;

  static int _int(Object? value) =>
      value is num ? value.toInt() : int.tryParse('$value') ?? 0;

  static List<String> _strings(Object? value) => value is List
      ? value.whereType<String>().toList(growable: false)
      : const <String>[];
}
