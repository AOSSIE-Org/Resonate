import 'package:flutter/material.dart';
import 'package:resonate/features/achievements/model/badge_category.dart';

// An extension, not ColorScheme slots: a badge colour must survive all six themes.
@immutable
class AchievementColors extends ThemeExtension<AchievementColors> {
  const AchievementColors({
    required this.hosting,
    required this.moderation,
    required this.echo,
    required this.rhythm,
    required this.core,
    required this.onBadge,
  });

  final Color hosting;
  final Color moderation;
  final Color echo;
  final Color rhythm;
  final Color core;
  final Color onBadge;

  static const AchievementColors light = AchievementColors(
    hosting: Color(0xFF2F5BD0),
    moderation: Color(0xFF6B3FC8),
    echo: Color(0xFFB85C0A),
    rhythm: Color(0xFFC62F45),
    core: Color(0xFF0B6E70),
    onBadge: Color(0xFFFFFFFF),
  );

  static const AchievementColors dark = AchievementColors(
    hosting: Color(0xFF4B77E5),
    moderation: Color(0xFF8A63DC),
    echo: Color(0xFFC2721B),
    rhythm: Color(0xFFE05266),
    core: Color(0xFF17908F),
    onBadge: Color(0xFFFFFFFF),
  );

  // Falls back by brightness so a bare ThemeData still renders badges.
  static AchievementColors of(BuildContext context) {
    final theme = Theme.of(context);
    return theme.extension<AchievementColors>() ??
        (theme.brightness == Brightness.dark ? dark : light);
  }

  Color forCategory(BadgeCategory category) => switch (category) {
    BadgeCategory.hosting => hosting,
    BadgeCategory.moderation => moderation,
    BadgeCategory.echo => echo,
    BadgeCategory.rhythm => rhythm,
    BadgeCategory.core => core,
  };

  @override
  AchievementColors copyWith({
    Color? hosting,
    Color? moderation,
    Color? echo,
    Color? rhythm,
    Color? core,
    Color? onBadge,
  }) {
    return AchievementColors(
      hosting: hosting ?? this.hosting,
      moderation: moderation ?? this.moderation,
      echo: echo ?? this.echo,
      rhythm: rhythm ?? this.rhythm,
      core: core ?? this.core,
      onBadge: onBadge ?? this.onBadge,
    );
  }

  @override
  AchievementColors lerp(
    covariant ThemeExtension<AchievementColors>? other,
    double t,
  ) {
    if (other is! AchievementColors) return this;
    return AchievementColors(
      hosting: Color.lerp(hosting, other.hosting, t)!,
      moderation: Color.lerp(moderation, other.moderation, t)!,
      echo: Color.lerp(echo, other.echo, t)!,
      rhythm: Color.lerp(rhythm, other.rhythm, t)!,
      core: Color.lerp(core, other.core, t)!,
      onBadge: Color.lerp(onBadge, other.onBadge, t)!,
    );
  }
}
