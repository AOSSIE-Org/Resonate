import 'package:resonate/features/achievements/data/repositories/achievements_repository.dart';
import 'package:resonate/features/achievements/model/achievement_badge.dart';
import 'package:resonate/features/achievements/model/badge_category.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/badge_catalogue.g.dart';

@Riverpod(keepAlive: true)
Future<List<AchievementBadge>> badgeCatalogue(Ref ref) =>
    ref.watch(achievementsRepositoryProvider).loadCatalogue();

@Riverpod(keepAlive: true)
Future<Map<BadgeCategory, List<AchievementBadge>>> badgeLadders(Ref ref) async {
  final badges = await ref.watch(badgeCatalogueProvider.future);
  final ladders = <BadgeCategory, List<AchievementBadge>>{};
  for (final badge in badges) {
    ladders.putIfAbsent(badge.category, () => []).add(badge);
  }
  for (final tiers in ladders.values) {
    tiers.sort((a, b) => a.threshold.compareTo(b.threshold));
  }
  // Iterate in enum order so the UI is stable whatever order the rows arrive in.
  return {
    for (final category in BadgeCategory.values)
      if (ladders[category] != null) category: ladders[category]!,
  };
}
