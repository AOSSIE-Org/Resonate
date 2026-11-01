import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:resonate/features/achievements/model/badge_category.dart';

part 'generated/achievement_badge.freezed.dart';

@freezed
abstract class AchievementBadge with _$AchievementBadge {
  const factory AchievementBadge({
    required String id,
    required BadgeCategory category,
    required BadgeMetric metric,
    required int threshold,
    required int tier,
  }) = _AchievementBadge;

  // Null rather than throwing, so one bad row cannot take out the catalogue.
  static AchievementBadge? fromMap(Map<String, dynamic> data) {
    final id = data['badgeId'] as String?;
    final category = BadgeCategory.fromWire(data['category'] as String?);
    final metric = BadgeMetric.fromWire(data['metric'] as String?);
    final threshold = data['threshold'];
    if (id == null || id.isEmpty || category == null || metric == null) {
      return null;
    }
    if (threshold is! num) return null;

    return AchievementBadge(
      id: id,
      category: category,
      metric: metric,
      threshold: threshold.toInt(),
      tier: (data['tier'] as num?)?.toInt() ?? 1,
    );
  }
}

const List<AchievementBadge> kDefaultBadges = [
  AchievementBadge(
    id: 'welcomer',
    category: BadgeCategory.hosting,
    metric: BadgeMetric.roomsHosted,
    threshold: 10,
    tier: 1,
  ),
  AchievementBadge(
    id: 'icon',
    category: BadgeCategory.hosting,
    metric: BadgeMetric.roomsHosted,
    threshold: 25,
    tier: 2,
  ),
  AchievementBadge(
    id: 'maestro',
    category: BadgeCategory.hosting,
    metric: BadgeMetric.roomsHosted,
    threshold: 50,
    tier: 3,
  ),
  AchievementBadge(
    id: 'guard',
    category: BadgeCategory.moderation,
    metric: BadgeMetric.roomsModerated,
    threshold: 10,
    tier: 1,
  ),
  AchievementBadge(
    id: 'sentinel',
    category: BadgeCategory.moderation,
    metric: BadgeMetric.roomsModerated,
    threshold: 25,
    tier: 2,
  ),
  AchievementBadge(
    id: 'warden',
    category: BadgeCategory.moderation,
    metric: BadgeMetric.roomsModerated,
    threshold: 50,
    tier: 3,
  ),
  AchievementBadge(
    id: 'echo',
    category: BadgeCategory.echo,
    metric: BadgeMetric.interactions,
    threshold: 50,
    tier: 1,
  ),
  AchievementBadge(
    id: 'rhythm',
    category: BadgeCategory.rhythm,
    metric: BadgeMetric.longestStreak,
    threshold: 7,
    tier: 1,
  ),
  AchievementBadge(
    id: 'core',
    category: BadgeCategory.core,
    metric: BadgeMetric.activeDays,
    threshold: 30,
    tier: 1,
  ),
];
