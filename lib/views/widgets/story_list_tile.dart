import 'package:flutter/material.dart';
import 'package:resonate/models/story.dart';
import 'package:resonate/views/screens/story_screen.dart';

class StoryListTile extends StatelessWidget {
  const StoryListTile({
    super.key,
    required this.story,
  });

  final Story story;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
        '${story.category.name} - ${story.creatorName}',
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontSize: 12,
              fontStyle: FontStyle.normal,
              fontFamily: 'Inter',
            ),
      ),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          story.coverImageUrl,
          fit: BoxFit.cover,
          height: 60,
          width: 60,
        ),
      ),
      trailing: const Icon(
        Icons.play_arrow_rounded,
        color: Colors.black38,
      ),
      tileColor: Colors.transparent,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoryScreen(
              story: story,
            ),
          ),
        );
      },
    );
  }
}
