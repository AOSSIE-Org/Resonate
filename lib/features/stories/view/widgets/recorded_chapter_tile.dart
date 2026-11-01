import 'package:flutter/material.dart';
import 'package:resonate/features/stories/model/recorded_chapter.dart';
import 'package:resonate/features/stories/view/story_format.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/shared/widgets/secondary_list_card.dart';
import 'package:resonate/utils/ui_sizes.dart';

class RecordedChapterTile extends StatelessWidget {
  const RecordedChapterTile({
    super.key,
    required this.chapter,
    required this.onTap,
  });

  final RecordedChapter chapter;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SecondaryListCard(
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(
          vertical: UiSizes.height_4,
          horizontal: UiSizes.width_5,
        ),
        leading: Container(
          width: UiSizes.width_45,
          height: UiSizes.width_45,
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(UiSizes.width_10),
          ),
          child: Icon(
            Icons.graphic_eq_rounded,
            color: colorScheme.primary,
            size: UiSizes.size_24,
          ),
        ),
        title: Text(
          recordedChapterTitle(chapter, l10n),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium!.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w500,
            fontSize: UiSizes.size_17,
            fontFamily: 'Inter',
          ),
        ),
        subtitle: Text(
          formatRecordedAt(chapter.recordedAt),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium!.copyWith(
            fontSize: UiSizes.size_12,
            fontFamily: 'Inter',
          ),
        ),
        trailing: Text(
          formatChapterLength(chapter.durationMs, l10n),
        ),
      ),
    );
  }
}

// A live chapter can be ended before it was ever named.
String recordedChapterTitle(RecordedChapter chapter, AppLocalizations l10n) {
  final title = chapter.title.trim();
  return title.isEmpty ? l10n.untitledRecording : title;
}
