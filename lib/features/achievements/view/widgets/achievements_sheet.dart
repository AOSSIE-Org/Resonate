import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/features/achievements/data/badge_catalogue.dart';
import 'package:resonate/features/achievements/data/badge_showcase.dart';
import 'package:resonate/features/achievements/data/my_stats.dart';
import 'package:resonate/features/achievements/model/achievement_badge.dart';
import 'package:resonate/features/achievements/model/badge_category.dart';
import 'package:resonate/features/achievements/model/known_badge.dart';
import 'package:resonate/features/achievements/model/user_stats.dart';
import 'package:resonate/features/achievements/view/widgets/badge_pill.dart';
import 'package:resonate/features/achievements/view/widgets/badge_visuals.dart';
import 'package:resonate/features/theme/model/achievement_colors.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/shared/widgets/snackbar.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/utils/ui_sizes.dart';

const int kMaxPillBadges = 2;

Future<void> showAchievementsSheet(
  BuildContext context, {
  required String uid,
  required bool isOwnProfile,
}) {
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    builder: (_) => DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scrollController) => AchievementsSheet(
        uid: uid,
        isOwnProfile: isOwnProfile,
        scrollController: scrollController,
      ),
    ),
  );
}

class AchievementsSheet extends ConsumerWidget {
  const AchievementsSheet({
    required this.uid,
    required this.isOwnProfile,
    this.scrollController,
    super.key,
  });

  final String uid;
  final bool isOwnProfile;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final stats = ref.watch(statsOfProvider(uid)) ?? UserStats.empty;
    final ladders = ref.watch(badgeLaddersProvider);

    return ListView(
      controller: scrollController,
      padding: EdgeInsets.fromLTRB(
        UiSizes.width_20,
        0,
        UiSizes.width_20,
        UiSizes.height_20,
      ),
      children: [
        Text(
          l10n.achievements,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: scheme.onSurface,
            fontWeight: FontWeight.w600,
            fontSize: UiSizes.size_18,
          ),
        ),
        SizedBox(height: UiSizes.height_4),
        Text(
          isOwnProfile
              ? l10n.achievementsSubtitle
              : l10n.creatorAchievementsSubtitle,
          style: TextStyle(
            color: scheme.onSurfaceVariant,
            fontSize: UiSizes.size_13,
          ),
        ),
        SizedBox(height: UiSizes.height_16),
        StatChipsRow(stats: stats),
        SizedBox(height: UiSizes.height_16),
        ladders.when(
          loading: () => Padding(
            padding: EdgeInsets.symmetric(vertical: UiSizes.height_20),
            child: const Center(child: CircularProgressIndicator()),
          ),
          // The catalogue falls back to defaults, so this is unreachable.
          error: (_, _) => const SizedBox.shrink(),
          data: (ladders) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final entry in ladders.entries)
                _CategoryProgress(
                  category: entry.key,
                  tiers: entry.value,
                  stats: stats,
                ),
              if (isOwnProfile) ...[
                SizedBox(height: UiSizes.height_10),
                _Showcase(stats: stats, ladders: ladders),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class StatChipsRow extends StatelessWidget {
  const StatChipsRow({required this.stats, super.key});

  final UserStats stats;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Wrap(
      spacing: UiSizes.width_8,
      runSpacing: UiSizes.height_8,
      children: [
        _StatChip(
          category: BadgeCategory.hosting,
          label: l10n.statRoomsHosted,
          value: '${stats.roomsHosted}',
        ),
        _StatChip(
          category: BadgeCategory.moderation,
          label: l10n.statRoomsModerated,
          value: '${stats.roomsModerated}',
        ),
        _StatChip(
          category: BadgeCategory.echo,
          label: l10n.statInteractions,
          value: '${stats.interactions}',
        ),
        _StatChip(
          category: BadgeCategory.rhythm,
          label: l10n.statStreak,
          value: '${stats.currentStreak}',
          footnote: l10n.statStreakBest(stats.longestStreak),
        ),
        _StatChip(
          category: BadgeCategory.core,
          label: l10n.statActiveDays,
          value: '${stats.activeDays}',
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.category,
    required this.label,
    required this.value,
    this.footnote,
  });

  final BadgeCategory category;
  final String label;
  final String value;
  final String? footnote;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = category.color(AchievementColors.of(context));
    final note = footnote;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: UiSizes.width_10,
        vertical: UiSizes.height_8,
      ),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // The footnote rides on the value line so every chip is two lines
          // tall and the grid does not come out ragged.
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(category.icon, size: UiSizes.size_14, color: accent),
              SizedBox(width: UiSizes.width_5),
              Text(
                value,
                style: TextStyle(
                  color: scheme.onSurface,
                  fontSize: UiSizes.size_17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (note != null) ...[
                SizedBox(width: UiSizes.width_5),
                Text(
                  note,
                  style: TextStyle(
                    color: scheme.onSurfaceVariant,
                    fontSize: UiSizes.size_12,
                  ),
                ),
              ],
            ],
          ),
          Text(
            label,
            style: TextStyle(
              color: scheme.onSurfaceVariant,
              fontSize: UiSizes.size_12,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryProgress extends StatelessWidget {
  const _CategoryProgress({
    required this.category,
    required this.tiers,
    required this.stats,
  });

  final BadgeCategory category;
  final List<AchievementBadge> tiers;
  final UserStats stats;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final colors = AchievementColors.of(context);
    final accent = category.color(colors);

    // From the badge list, not the metric: a lapsed streak keeps its badge.
    final held = tiers.where((tier) => stats.hasEarned(tier.id)).toList();
    final current = held.isEmpty ? null : held.last;
    final next = tiers
        .where((tier) => tier.threshold > (current?.threshold ?? -1))
        .firstOrNull;

    final value = stats.valueOf(tiers.first.metric);
    final progress = next == null
        ? 1.0
        : (value / next.threshold).clamp(0.0, 1.0);

    return Padding(
      padding: EdgeInsets.only(bottom: UiSizes.height_16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: UiSizes.size_35,
                height: UiSizes.size_35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: current == null ? scheme.secondaryContainer : accent,
                ),
                child: Icon(
                  current == null
                      ? category.icon
                      : badgeIcon(current.id, category),
                  size: UiSizes.size_18,
                  color: current == null
                      ? scheme.onSurfaceVariant
                      : colors.onBadge,
                ),
              ),
              SizedBox(width: UiSizes.width_10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.label(l10n),
                      style: TextStyle(
                        color: scheme.onSurface,
                        fontSize: UiSizes.size_15,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      current == null
                          ? l10n.badgeLocked
                          : badgeLabel(current.id, category, l10n),
                      style: TextStyle(
                        color: current == null
                            ? scheme.onSurfaceVariant
                            : accent,
                        fontSize: UiSizes.size_13,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: UiSizes.width_8),
              if (next != null)
                Text(
                  l10n.badgeProgress(value, next.threshold),
                  style: TextStyle(
                    color: scheme.onSurfaceVariant,
                    fontSize: UiSizes.size_12,
                  ),
                )
              else
                Icon(
                  Icons.check_circle_rounded,
                  size: UiSizes.size_18,
                  color: accent,
                ),
            ],
          ),
          SizedBox(height: UiSizes.height_8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: UiSizes.height_5,
              backgroundColor: scheme.secondaryContainer,
              valueColor: AlwaysStoppedAnimation<Color>(accent),
            ),
          ),
          if (next != null) ...[
            SizedBox(height: UiSizes.height_4),
            Text(
              badgeRequirement(next, l10n),
              style: TextStyle(
                color: scheme.onSurfaceVariant,
                fontSize: UiSizes.size_12,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Showcase extends ConsumerWidget {
  const _Showcase({required this.stats, required this.ladders});

  final UserStats stats;
  final Map<BadgeCategory, List<AchievementBadge>> ladders;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    final earned = [
      for (final badge in KnownBadge.values)
        if (stats.hasEarned(badge.id)) badge,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(height: UiSizes.height_30),
        Text(
          l10n.showOnProfile,
          style: TextStyle(
            color: scheme.onSurface,
            fontSize: UiSizes.size_15,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: UiSizes.height_4),
        Text(
          earned.isEmpty ? l10n.noBadgesYet : l10n.showOnProfileHint,
          style: TextStyle(
            color: scheme.onSurfaceVariant,
            fontSize: UiSizes.size_12,
          ),
        ),
        SizedBox(height: UiSizes.height_10),
        for (final badge in earned)
          _ShowcaseRow(
            badge: badge,
            isPill: stats.displayedBadges.contains(badge.id),
            isAvatar: stats.avatarBadge == badge.id,
            onTogglePill: () => _togglePill(context, ref, badge),
            onToggleAvatar: () => _toggleAvatar(context, ref, badge),
          ),
      ],
    );
  }

  Future<void> _togglePill(
    BuildContext context,
    WidgetRef ref,
    KnownBadge badge,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final displayed = [...stats.displayedBadges];

    if (displayed.remove(badge.id)) {
      await _save(l10n, ref, displayed, stats.avatarBadge);
      return;
    }
    if (displayed.length >= kMaxPillBadges) {
      customSnackbar(
        l10n.achievements,
        l10n.badgePillLimitReached,
        LogType.info,
      );
      return;
    }
    await _save(l10n, ref, [...displayed, badge.id], stats.avatarBadge);
  }

  Future<void> _toggleAvatar(
    BuildContext context,
    WidgetRef ref,
    KnownBadge badge,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final wearing = stats.avatarBadge == badge.id;
    await _save(l10n, ref, stats.displayedBadges, wearing ? null : badge.id);
  }

  Future<void> _save(
    AppLocalizations l10n,
    WidgetRef ref,
    List<String> displayedBadges,
    String? avatarBadge,
  ) async {
    final saved = await ref
        .read(myStatsProvider.notifier)
        .setShowcase(
          displayedBadges: displayedBadges,
          avatarBadge: avatarBadge,
        );
    if (!saved) {
      customSnackbar(l10n.error, l10n.badgeShowcaseFailed, LogType.error);
    }
  }
}

class _ShowcaseRow extends StatelessWidget {
  const _ShowcaseRow({
    required this.badge,
    required this.isPill,
    required this.isAvatar,
    required this.onTogglePill,
    required this.onToggleAvatar,
  });

  final KnownBadge badge;
  final bool isPill;
  final bool isAvatar;
  final VoidCallback onTogglePill;
  final VoidCallback onToggleAvatar;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: UiSizes.height_4),
      child: Row(
        children: [
          // One Expanded, not Flexible + Spacer: both default to flex 1 and
          // would split the free space, putting the toggles at a different x
          // on every row.
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: BadgePill(badge: badge),
            ),
          ),
          IconButton(
            onPressed: onTogglePill,
            tooltip: l10n.badgeShownAsPill,
            icon: Icon(
              isPill ? Icons.label : Icons.label_outline,
              color: isPill ? scheme.primary : scheme.onSurfaceVariant,
            ),
          ),
          IconButton(
            onPressed: onToggleAvatar,
            tooltip: l10n.badgeShownOnAvatar,
            icon: Icon(
              isAvatar ? Icons.account_circle : Icons.account_circle_outlined,
              color: isAvatar ? scheme.primary : scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
