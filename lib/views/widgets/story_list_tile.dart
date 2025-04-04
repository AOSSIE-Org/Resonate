import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:resonate/models/story.dart';
import 'package:resonate/utils/colors.dart';
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
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w500,
              fontSize: 17,
              fontStyle: FontStyle.normal,
              fontFamily: 'Inter',
            ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            story.creatorName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 12,
                  fontStyle: FontStyle.normal,
                  fontFamily: 'Inter',
                ),
          ),
          Container(
              margin: const EdgeInsets.only(top: 5),
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                  color: AppColor
                      .categoryColorList[story.category.name.toLowerCase()],
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                story.category.name.capitalizeFirst ?? "",
                maxLines: 1,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 12,
                    fontStyle: FontStyle.normal,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold),
              )),
        ],
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
      trailing: Icon(
        Icons.play_arrow_rounded,
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[400]
            : Colors.black38,
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
