import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/features/profile/data/user_avatars.dart';
import 'package:resonate/features/theme/viewmodel/theme_notifier.dart';
import 'package:resonate/shared/widgets/speaking_avatar.dart';
import 'package:resonate/utils/ui_sizes.dart';


class SpeakingProfileAvatar extends ConsumerWidget {
  const SpeakingProfileAvatar({
    super.key,
    required this.uid,
    required this.imageUrl,
    required this.radius,
  });

  final String uid;
  final String imageUrl;
  final double radius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final best = bestAvatarUrl(ref, uid: uid, stored: imageUrl);
    final url = best.isEmpty
        ? ref.watch(userProfileImagePlaceholderUrlProvider)
        : best;

    return SpeakingAvatar(
      uid: uid,
      radius: radius,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: scheme.primary,
        child: CircleAvatar(
          radius: radius - UiSizes.width_2,
          backgroundColor: scheme.surfaceContainerHighest,
          foregroundImage: NetworkImage(url),
        ),
      ),
    );
  }
}
