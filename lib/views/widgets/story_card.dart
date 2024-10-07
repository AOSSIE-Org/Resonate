import 'package:flutter/material.dart';
import 'package:resonate/models/story.dart';

class StoryCard extends StatelessWidget {
  const StoryCard({super.key, required this.story});
  final Story story;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 150,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                story.coverImageUrl,
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
            '# ${story.title}',
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
