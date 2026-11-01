import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/features/achievements/view/widgets/badge_mark.dart';
import 'package:resonate/features/theme/model/activity_status_colors.dart';
import 'package:resonate/features/theme/viewmodel/theme_notifier.dart';
import 'package:resonate/shared/widgets/speaking_avatar.dart';
import 'package:resonate/utils/ui_sizes.dart';


String resolveAvatarUrl(WidgetRef ref, String? url) => (url ?? '').isEmpty
    ? ref.watch(userProfileImagePlaceholderUrlProvider)
    : url!;


class SessionParticipantCard extends ConsumerWidget {
  const SessionParticipantCard({
    super.key,
    required this.uid,
    required this.name,
    required this.role,
    this.avatarUrl,
    this.featured = false,
    this.isMicOn,
    this.handRaised = false,
  });

  final String uid;

  final String name;

  final String role;

  final String? avatarUrl;

  final bool featured;

  final bool? isMicOn;

  final bool handRaised;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final url = resolveAvatarUrl(ref, avatarUrl);
    return featured ? _featured(context, url) : _tile(context, url);
  }

  Widget _featured(BuildContext context, String avatarUrl) {
    return _Card(
      padding: EdgeInsets.symmetric(
        horizontal: UiSizes.width_25,
        vertical: UiSizes.height_26,
      ),
      child: Row(
        children: [
          _avatar(
            context,
            avatarUrl,
            radius: UiSizes.size_65,
            badgeSize: UiSizes.size_30,
          ),
          SizedBox(width: UiSizes.width_16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name.split(' ').first,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: UiSizes.size_30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  role,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: UiSizes.size_20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tile(BuildContext context, String avatarUrl) {
    return _Card(
      padding: EdgeInsets.symmetric(
        vertical: UiSizes.height_15,
        horizontal: UiSizes.width_4,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _avatar(
            context,
            avatarUrl,
            radius: UiSizes.size_26,
            badgeSize: UiSizes.size_18,
          ),
          SizedBox(height: UiSizes.height_8),
          Text(
            name.split(' ').first,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: UiSizes.size_18,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            role,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: UiSizes.size_15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatar(
    BuildContext context,
    String avatarUrl, {
    required double radius,
    required double badgeSize,
  }) {
    // A field cannot be promoted, and the dot is drawn only when it is set.
    final micOn = isMicOn;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SpeakingAvatar(
          uid: uid,
          radius: radius,
          child: CircleAvatar(
            radius: radius,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: CircleAvatar(
              radius: radius - UiSizes.width_2,
              backgroundColor: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest,
              foregroundImage: NetworkImage(avatarUrl),
            ),
          ),
        ),
        Positioned(
          left: 0,
          bottom: 0,
          child: BadgeMark(uid: uid, size: badgeSize),
        ),
        if (micOn != null)
          Positioned(
            right: 0,
            bottom: 0,
            child: _MicDot(isMicOn: micOn, size: badgeSize),
          ),
        if (handRaised)
          Positioned(
            right: 0,
            top: 0,
            child: Icon(
              Icons.waving_hand_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: badgeSize,
            ),
          ),
      ],
    );
  }
}

// Shared surface for both card shapes.
class _Card extends StatelessWidget {
  const _Card({required this.padding, required this.child});

  final EdgeInsetsGeometry padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(UiSizes.width_16),
      ),
      child: child,
    );
  }
}

// Mic state as a filled disc on the avatar
class _MicDot extends StatelessWidget {
  const _MicDot({required this.isMicOn, required this.size});

  final bool isMicOn;
  final double size;

  @override
  Widget build(BuildContext context) {
    final statusColors = ActivityStatusColors.of(context);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isMicOn
            ? statusColors.online
            : Theme.of(context).colorScheme.error,
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary,
          width: UiSizes.width_1_5,
        ),
      ),
      child: Center(
        child: Icon(
          isMicOn ? Icons.mic : Icons.mic_off,
          size: size * 0.6,
          color: statusColors.onStatus,
        ),
      ),
    );
  }
}
