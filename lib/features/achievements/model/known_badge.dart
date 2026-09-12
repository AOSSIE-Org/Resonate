import 'package:resonate/features/achievements/model/badge_category.dart';

// The ids this build ships artwork for; anything else falls back to its category.
enum KnownBadge {
  welcomer('welcomer', BadgeCategory.hosting),
  icon('icon', BadgeCategory.hosting),
  maestro('maestro', BadgeCategory.hosting),
  guard('guard', BadgeCategory.moderation),
  sentinel('sentinel', BadgeCategory.moderation),
  warden('warden', BadgeCategory.moderation),
  echo('echo', BadgeCategory.echo),
  rhythm('rhythm', BadgeCategory.rhythm),
  core('core', BadgeCategory.core);

  const KnownBadge(this.id, this.category);

  final String id;
  final BadgeCategory category;

  static KnownBadge? fromId(String? id) {
    if (id == null) return null;
    for (final badge in KnownBadge.values) {
      if (badge.id == id) return badge;
    }
    return null;
  }
}
