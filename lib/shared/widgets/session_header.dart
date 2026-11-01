import 'package:flutter/material.dart';
import 'package:resonate/utils/ui_sizes.dart';

/// Title/description header shared by live rooms, pair chat and friend calls
/// (used without [SessionAppBar] on the friend-call screen — keep them separate).
class SessionHeader extends StatelessWidget {
  const SessionHeader({
    super.key,
    required this.title,
    required this.description,
    this.tags,
  });
  final String title;
  final String description;
  final String? tags;

  @override
  Widget build(BuildContext context) {
    final mutedColor = Theme.of(context).colorScheme.onSurfaceVariant;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: UiSizes.size_20)),
        SizedBox(height: UiSizes.height_8),
        Text(
          tags ?? '',
          style: TextStyle(
            fontSize: UiSizes.size_15,
            fontWeight: FontWeight.w100,
            color: mutedColor,
          ),
        ),
        SizedBox(height: UiSizes.height_7),
        Text(
          description,
          style: TextStyle(color: mutedColor, fontSize: UiSizes.size_14),
        ),
      ],
    );
  }
}
