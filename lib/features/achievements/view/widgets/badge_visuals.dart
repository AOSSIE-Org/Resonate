import 'package:flutter/material.dart';
import 'package:resonate/features/achievements/model/achievement_badge.dart';
import 'package:resonate/features/achievements/model/badge_category.dart';
import 'package:resonate/features/achievements/model/known_badge.dart';
import 'package:resonate/features/theme/model/achievement_colors.dart';
import 'package:resonate/l10n/app_localizations.dart';

extension KnownBadgePresentation on KnownBadge {
  IconData get icon => switch (this) {
    KnownBadge.welcomer => Icons.waving_hand_rounded,
    KnownBadge.icon => Icons.star_rounded,
    KnownBadge.maestro => Icons.workspace_premium_rounded,
    KnownBadge.guard => Icons.shield_rounded,
    KnownBadge.sentinel => Icons.security_rounded,
    KnownBadge.warden => Icons.gavel_rounded,
    KnownBadge.echo => Icons.graphic_eq_rounded,
    KnownBadge.rhythm => Icons.local_fire_department_rounded,
    KnownBadge.core => Icons.diamond_rounded,
  };

  String label(AppLocalizations l10n) => switch (this) {
    KnownBadge.welcomer => l10n.badgeWelcomer,
    KnownBadge.icon => l10n.badgeIcon,
    KnownBadge.maestro => l10n.badgeMaestro,
    KnownBadge.guard => l10n.badgeGuard,
    KnownBadge.sentinel => l10n.badgeSentinel,
    KnownBadge.warden => l10n.badgeWarden,
    KnownBadge.echo => l10n.badgeEcho,
    KnownBadge.rhythm => l10n.badgeRhythm,
    KnownBadge.core => l10n.badgeCore,
  };

  Color color(AchievementColors colors) => colors.forCategory(category);
}

extension BadgeCategoryPresentation on BadgeCategory {
  IconData get icon => switch (this) {
    BadgeCategory.hosting => Icons.campaign_rounded,
    BadgeCategory.moderation => Icons.shield_rounded,
    BadgeCategory.echo => Icons.forum_rounded,
    BadgeCategory.rhythm => Icons.local_fire_department_rounded,
    BadgeCategory.core => Icons.diamond_rounded,
  };

  String label(AppLocalizations l10n) => switch (this) {
    BadgeCategory.hosting => l10n.badgeCategoryHosting,
    BadgeCategory.moderation => l10n.badgeCategoryModeration,
    BadgeCategory.echo => l10n.badgeCategoryEcho,
    BadgeCategory.rhythm => l10n.badgeCategoryRhythm,
    BadgeCategory.core => l10n.badgeCategoryCore,
  };
  String statLabel(AppLocalizations l10n) => switch (this) {
    BadgeCategory.hosting => l10n.statRoomsHosted,
    BadgeCategory.moderation => l10n.statRoomsModerated,
    BadgeCategory.echo => l10n.statInteractions,
    BadgeCategory.rhythm => l10n.statStreak,
    BadgeCategory.core => l10n.statActiveDays,
  };

  Color color(AchievementColors colors) => colors.forCategory(this);
}

// Uses the badge's own threshold, so retuning it server-side keeps this true.
String badgeRequirement(AchievementBadge badge, AppLocalizations l10n) =>
    switch (badge.category) {
      BadgeCategory.hosting => l10n.badgeHostingDescription(badge.threshold),
      BadgeCategory.moderation => l10n.badgeModerationDescription(
        badge.threshold,
      ),
      BadgeCategory.echo => l10n.badgeEchoDescription(badge.threshold),
      BadgeCategory.rhythm => l10n.badgeRhythmDescription(badge.threshold),
      BadgeCategory.core => l10n.badgeCoreDescription(badge.threshold),
    };

String badgeLabel(
  String badgeId,
  BadgeCategory category,
  AppLocalizations l10n,
) => KnownBadge.fromId(badgeId)?.label(l10n) ?? category.label(l10n);

IconData badgeIcon(String badgeId, BadgeCategory category) =>
    KnownBadge.fromId(badgeId)?.icon ?? category.icon;
