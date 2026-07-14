import 'package:flutter/material.dart';
import 'package:resonate/features/stories/model/chapter.dart';
import 'package:resonate/features/stories/view/story_format.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/shared/widgets/secondary_list_card.dart';

class ChapterListTile extends StatelessWidget {
  const ChapterListTile({super.key, required this.chapter});

  final Chapter chapter;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SecondaryListCard(
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          vertical: UiSizes.height_4,
          horizontal: UiSizes.width_5,
        ),
        leading: SizedBox(
          width: UiSizes.width_45,
          height: UiSizes.width_45,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(UiSizes.width_10),
            child: Image.network(chapter.coverImageUrl, fit: BoxFit.cover),
          ),
        ),
        title: Text(
          chapter.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w500,
            fontSize: UiSizes.size_17,
            fontFamily: 'Inter',
          ),
        ),
        subtitle: Text(
          chapter.description,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: UiSizes.size_12,
            fontFamily: 'Inter',
          ),
        ),
        trailing: Text(
          '${formatPlayDuration(chapter.playDuration)} ${AppLocalizations.of(context)!.lengthMinutes}',
        ),
      ),
    );
  }
}
