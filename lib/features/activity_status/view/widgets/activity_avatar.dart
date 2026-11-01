import 'package:flutter/material.dart';
import 'package:resonate/features/activity_status/view/widgets/activity_dot.dart';
import 'package:resonate/utils/enums/activity_status.dart';
import 'package:resonate/utils/ui_sizes.dart';


class ActivityAvatar extends StatelessWidget {
  const ActivityAvatar({
    required this.imageUrl,
    required this.status,
    required this.radius,
    this.dotSize,
    this.backgroundColor,
    super.key,
  });

  final String? imageUrl;
  final ActivityStatus? status;
  final double radius;
  final double? dotSize;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final url = imageUrl;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: backgroundColor ?? scheme.secondaryContainer,
          backgroundImage: (url == null || url.isEmpty)
              ? null
              : NetworkImage(url),
          child: (url == null || url.isEmpty)
              ? Icon(Icons.person_outline, size: radius)
              : null,
        ),
        if (status != null)
          Positioned(
            right: 0,
            bottom: 0,
            child: ActivityDot(
              status: status!,
              size: dotSize ?? UiSizes.size_14,
              borderColor: scheme.surface,
            ),
          ),
      ],
    );
  }
}
