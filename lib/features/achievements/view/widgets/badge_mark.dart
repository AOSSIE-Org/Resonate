import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/features/achievements/data/badge_showcase.dart';
import 'package:resonate/features/achievements/view/widgets/badge_visuals.dart';
import 'package:resonate/features/theme/model/achievement_colors.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/ui_sizes.dart';

// For avatars with no status dot; where there is one, use ActivityAvatar.badgeGlyph.
class BadgeMark extends ConsumerWidget {
  const BadgeMark({required this.uid, this.size, super.key});

  final String uid;
  final double? size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final badge = ref.watch(avatarBadgeProvider(uid));
    if (badge == null) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;
    final colors = AchievementColors.of(context);
    final scheme = Theme.of(context).colorScheme;
    final discSize = size ?? UiSizes.size_20;

    return Semantics(
      label: badge.label(l10n),
      child: Container(
        width: discSize,
        height: discSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: badge.color(colors),
          border: Border.all(color: scheme.surface, width: UiSizes.width_2),
        ),
        child: Center(
          child: Icon(badge.icon, size: discSize * 0.62, color: colors.onBadge),
        ),
      ),
    );
  }
}
