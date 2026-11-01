import 'package:flutter/material.dart';
import 'package:resonate/utils/ui_sizes.dart';

class LiveChapterHeader extends StatelessWidget {
  const LiveChapterHeader({
    super.key,
    required this.chapterName,
    required this.chapterDescription,
  });
  final String chapterName;
  final String chapterDescription;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(chapterName, style: TextStyle(fontSize: UiSizes.size_20)),
        SizedBox(height: UiSizes.height_8),
        Text(
          chapterDescription,
          style: TextStyle(
            color: colorScheme.onSurface.withValues(alpha: 0.6),
            fontSize: UiSizes.size_14,
          ),
        ),
      ],
    );
  }
}
