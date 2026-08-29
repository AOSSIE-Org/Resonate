import 'package:resonate/features/achievements/data/my_stats.dart';
import 'package:resonate/features/achievements/data/user_stats_provider.dart';
import 'package:resonate/features/achievements/model/known_badge.dart';
import 'package:resonate/features/achievements/model/user_stats.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/badge_showcase.g.dart';

@Riverpod(keepAlive: true)
UserStats? statsOf(Ref ref, String uid) {
  final me = ref.watch(currentUserProvider)?.uid;
  return uid == me
      ? ref.watch(myStatsProvider).value
      : ref.watch(userStatsProvider(uid)).value;
}

@Riverpod(keepAlive: true)
KnownBadge? avatarBadge(Ref ref, String uid) =>
    KnownBadge.fromId(ref.watch(statsOfProvider(uid))?.avatarBadge);

@Riverpod(keepAlive: true)
List<KnownBadge> displayedBadges(Ref ref, String uid) {
  final displayed = ref.watch(statsOfProvider(uid))?.displayedBadges;
  if (displayed == null || displayed.isEmpty) return const [];
  return [
    for (final badge in KnownBadge.values)
      if (displayed.contains(badge.id)) badge,
  ];
}
