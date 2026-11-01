import 'package:flutter/material.dart';
import 'package:resonate/features/stories/model/story.dart';
import 'package:resonate/features/stories/view/pages/story_page.dart';
import 'package:resonate/utils/ui_sizes.dart';

class StoryCard extends StatelessWidget {
  const StoryCard({super.key, required this.story});
  final Story story;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => StoryPage(story: story)),
      ),
      child: Stack(
        children: [
          Container(
            width: UiSizes.width_180,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(story.coverImageUrl),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(UiSizes.width_5),
            ),
          ),
          Positioned(
            left: UiSizes.width_16,
            bottom: UiSizes.height_14,
            child: Text(
              '# ${story.title}',
              // Overlaid on the cover image
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Colors.white,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w900,
                fontSize: UiSizes.size_19,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
