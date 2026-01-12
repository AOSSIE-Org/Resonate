import 'package:flutter/material.dart';
import '../../utils/badge_constants.dart';

class BadgeRow extends StatelessWidget {
  final List<String> userBadges;

  const BadgeRow({Key? key, required this.userBadges}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (userBadges.isEmpty) return SizedBox.shrink(); // Hide if no badges

    return Wrap(
      spacing: 8.0, // Space between badges
      children: userBadges.map((badgeId) {
        // Find the image path for this badge ID
        final iconPath = BadgeConstants.icons[badgeId];
        
        // If we define a badge in DB but forget the image, don't crash
        if (iconPath == null) return SizedBox.shrink();

        return Tooltip(
          message: BadgeConstants.tooltips[badgeId] ?? '',
          triggerMode: TooltipTriggerMode.tap,
          child: Image.asset(
            iconPath,
            width: 35, // Size of the badge
            height: 35,
          ),
        );
      }).toList(),
    );
  }
}