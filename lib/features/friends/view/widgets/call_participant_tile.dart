import 'package:flutter/material.dart';
import 'package:resonate/features/achievements/view/widgets/badge_mark.dart';
import 'package:resonate/shared/widgets/speaking_profile_avatar.dart';
import 'package:resonate/utils/ui_sizes.dart';

class CallParticipantTile extends StatelessWidget {
  const CallParticipantTile({
    super.key,
    required this.uid,
    required this.name,
    required this.imageUrl,
    this.compact = false,
  });

  final String uid;
  final String name;
  final String imageUrl;

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? UiSizes.width_8 : UiSizes.width_25,
        vertical: compact ? UiSizes.height_12 : UiSizes.height_26,
      ),
      decoration: BoxDecoration(
        color: compact ? scheme.surfaceContainerHighest : scheme.secondary,
        borderRadius: BorderRadius.circular(UiSizes.width_16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _avatar(context),
          SizedBox(height: compact ? UiSizes.height_8 : UiSizes.height_16),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: compact ? UiSizes.size_16 : UiSizes.size_30,
              fontWeight: compact ? FontWeight.w600 : FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatar(BuildContext context) {
    final radius = compact ? UiSizes.size_26 : UiSizes.size_70;
    final markSize = compact ? UiSizes.size_16 : UiSizes.size_30;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        SpeakingProfileAvatar(uid: uid, imageUrl: imageUrl, radius: radius),
        if (!compact)
          Positioned(
            left: 0,
            bottom: 0,
            child: BadgeMark(uid: uid, size: markSize),
          ),
      ],
    );
  }
}
