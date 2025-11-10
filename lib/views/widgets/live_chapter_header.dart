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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          chapterName,
          style: TextStyle(
            fontSize: UiSizes.size_20,
            // color: Colors.black,
          ),
        ),
        SizedBox(height: UiSizes.height_8),

        Text(
          chapterDescription,
          style: TextStyle(color: Colors.grey, fontSize: UiSizes.size_14),
        ),
      ],
    );
  }
}
