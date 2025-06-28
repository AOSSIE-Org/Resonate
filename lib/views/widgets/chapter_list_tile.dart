import 'package:flutter/material.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/models/chapter.dart';
import 'package:resonate/views/screens/create_story_screen.dart';

class ChaperListTile extends StatelessWidget {
  const ChaperListTile({
    super.key,
    required this.chapter,
  });

  final Chapter chapter;

  @override
  Widget build(BuildContext context) {
    return Container(
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
        contentPadding: const EdgeInsets.symmetric(
          vertical: 4.0,
          horizontal: 5.0,
        ),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Image.network(
            chapter.coverImageUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          chapter.title,
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
          chapter.description,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 12,
                fontStyle: FontStyle.normal,
                fontFamily: 'Inter',
              ),
        ),
        trailing: Text(
            '${formatPlayDuration(chapter.playDuration)} ${AppLocalizations.of(context)!.lengthMinutes}'),
      ),
    );
  }
}
