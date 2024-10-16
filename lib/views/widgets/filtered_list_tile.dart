import 'package:flutter/material.dart';
import 'package:resonate/models/story.dart';
import 'package:resonate/views/screens/story_details_screen.dart';

class FilteredListTile extends StatelessWidget {
  final Story story;

  const FilteredListTile({required this.story, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoryDetailsScreen(
              story: story,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.secondary,
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: CircleAvatar(
            backgroundImage: AssetImage(story.coverImageUrl),
            radius: 25,
          ),
          trailing: Text(
            ' 10 min ago',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 14,
                  fontStyle: FontStyle.normal,
                  fontFamily: 'Inter',
                ),
          ),
          title: Text(
            story.title,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                  fontStyle: FontStyle.normal,
                  fontFamily: 'Inter',
                ),
          ),
          subtitle: Text(
            'Created by ${story.creatorName}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 12,
                  fontStyle: FontStyle.normal,
                  fontFamily: 'Inter',
                ),
          ),
        ),
      ),
    );
  }
}
