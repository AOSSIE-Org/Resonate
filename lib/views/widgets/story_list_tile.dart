import 'package:flutter/material.dart';
import 'package:resonate/models/story.dart';

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
        ),
      ),
      trailing: Icon(
        Icons.play_arrow_rounded,
        color: Colors.grey[350],
      ),
      tileColor: Colors.transparent,
      onTap: () {},
    );
  }
}
