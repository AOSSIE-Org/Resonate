import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/features/achievements/data/badge_showcase.dart';
import 'package:resonate/features/achievements/model/known_badge.dart';
import 'package:resonate/features/achievements/view/widgets/badge_visuals.dart';
import 'package:resonate/features/theme/model/achievement_colors.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/ui_sizes.dart';

class BadgePill extends StatelessWidget {
  const BadgePill({required this.badge, super.key});

  final KnownBadge badge;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = AchievementColors.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: UiSizes.width_8,
        vertical: UiSizes.height_2,
      ),
      decoration: BoxDecoration(
        color: badge.color(colors),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(badge.icon, size: UiSizes.size_13, color: colors.onBadge),
          SizedBox(width: UiSizes.width_4),
          Flexible(
            child: Text(
              badge.label(l10n),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: colors.onBadge,
                fontSize: UiSizes.size_12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Always one line: Flexible lets the pills compress and ellipsize when the name
// beside them is long, rather than wrapping onto a second row.
class BadgePillRow extends ConsumerWidget {
  const BadgePillRow({required this.uid, super.key});

  final String uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final badges = ref.watch(displayedBadgesProvider(uid));
    if (badges.isEmpty) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < badges.length; i++) ...[
          if (i > 0) SizedBox(width: UiSizes.width_5),
          Flexible(child: BadgePill(badge: badges[i])),
        ],
      ],
    );
  }
}
