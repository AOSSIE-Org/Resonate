import 'package:flutter/material.dart';
import 'package:resonate/features/stories/model/story.dart';
import 'package:resonate/features/stories/view/pages/story_page.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/colors.dart';
import 'package:resonate/utils/ui_sizes.dart';

class StoryListTile extends StatelessWidget {
  const StoryListTile({super.key, required this.story});

  final Story story;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UiSizes.width_10),
      ),
      title: Text(
        story.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w500,
          fontSize: UiSizes.size_17,
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
              fontSize: UiSizes.size_12,
              fontFamily: 'Inter',
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: UiSizes.height_5),
            padding: EdgeInsets.all(UiSizes.width_3),
            decoration: BoxDecoration(
              color:
                  AppColor.categoryColorList[story.category.name.toLowerCase()],
              borderRadius: BorderRadius.circular(UiSizes.width_10),
            ),
            child: Text(
              AppLocalizations.of(
                context,
              )!.storyCategory(story.category.name.toLowerCase()),
              maxLines: 1,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: UiSizes.size_12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      leading: SizedBox(
        width: UiSizes.width_56,
        height: UiSizes.width_56,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(UiSizes.width_10),
          child: Image.network(story.coverImageUrl, fit: BoxFit.cover),
        ),
      ),
      trailing: Icon(
        Icons.play_arrow_rounded,
        color: colorScheme.onSurface.withValues(alpha: 0.45),
      ),
      tileColor: Colors.transparent,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => StoryPage(story: story)),
      ),
    );
  }
}
