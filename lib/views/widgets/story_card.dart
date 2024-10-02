import 'package:flutter/material.dart';
import 'package:resonate/models/story_model.dart';

class StoryCard extends StatelessWidget {
  const StoryCard({super.key, required this.storyModel});
  final StoryModel storyModel;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 150,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                storyModel.image,
              ),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        Positioned(
          left: 14,
          // top: 14,
          bottom: 14,
          child: Text(
            '# ${storyModel.name}',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Colors.white,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w900,
                  fontSize: 19,
                ),
          ),
        ),
      ],
    );
  }
}
