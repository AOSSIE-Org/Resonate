import 'package:flutter/material.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/models/live_chapter_model.dart';

class LiveChapterListTile extends StatelessWidget {
  const LiveChapterListTile({super.key, required this.chapter});

  final LiveChapterModel chapter;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.secondary,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 4.0,
          horizontal: 5.0,
        ),
        leading: Icon(Icons.play_circle_outline, color: Colors.red),
        title: Text(
          chapter.chapterTitle,
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
        subtitle: Text(
          chapter.chapterDescription,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: 12,
            fontStyle: FontStyle.normal,
            fontFamily: 'Inter',
          ),
        ),
        trailing: Text(AppLocalizations.of(context)!.live),
      ),
    );
  }
}
