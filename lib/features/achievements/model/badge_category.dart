// A user holds at most one badge per category: the highest tier they qualify for.
enum BadgeCategory {
  hosting('hosting'),
  moderation('moderation'),
  echo('echo'),
  rhythm('rhythm'),
  core('core');

  const BadgeCategory(this.wire);

  final String wire;

  static BadgeCategory? fromWire(String? wire) {
    if (wire == null) return null;
    for (final category in BadgeCategory.values) {
      if (category.wire == wire) return category;
    }
    return null;
  }
}

// Rhythm uses longestStreak: badges are never revoked, so it must only grow.
enum BadgeMetric {
  roomsHosted('roomsHosted'),
  roomsModerated('roomsModerated'),
  interactions('interactions'),
  currentStreak('currentStreak'),
  longestStreak('longestStreak'),
  activeDays('activeDays');

  const BadgeMetric(this.wire);

  final String wire;

  static BadgeMetric? fromWire(String? wire) {
    if (wire == null) return null;
    for (final metric in BadgeMetric.values) {
      if (metric.wire == wire) return metric;
    }
    return null;
  }
}
