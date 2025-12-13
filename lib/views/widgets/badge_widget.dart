import 'package:flutter/material.dart';
import 'package:resonate/utils/badge_constants.dart';
import 'package:resonate/utils/ui_sizes.dart';

/// Widget to display user badges.
/// Shows badge icons with tooltips on hover.
class BadgeWidget extends StatelessWidget {
  const BadgeWidget({
    super.key,
    required this.badges,
    this.size = 16,
  });

  final List<String> badges;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (badges.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: badges.map((badge) {
        return Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Tooltip(
            message: BadgeConstants.getBadgeDescription(badge),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getBadgeColor(badge),
                border: Border.all(
                  color: Theme.of(context).colorScheme.surface,
                  width: 1,
                ),
              ),
              child: Icon(
                _getBadgeIcon(badge),
                size: size * 0.6,
                color: Colors.white,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _getBadgeColor(String badge) {
    switch (badge) {
      case BadgeConstants.anchor:
        return Colors.blue;
      case BadgeConstants.storyteller:
        return Colors.purple;
      case BadgeConstants.crowdFavorite:
        return Colors.orange;
      case BadgeConstants.conversationalist:
        return Colors.green;
      case BadgeConstants.audiophile:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getBadgeIcon(String badge) {
    switch (badge) {
      case BadgeConstants.anchor:
        return Icons.anchor;
      case BadgeConstants.storyteller:
        return Icons.menu_book;
      case BadgeConstants.crowdFavorite:
        return Icons.favorite;
      case BadgeConstants.conversationalist:
        return Icons.chat;
      case BadgeConstants.audiophile:
        return Icons.headphones;
      default:
        return Icons.star;
    }
  }
}

