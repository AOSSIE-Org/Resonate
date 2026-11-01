import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/features/stories/model/live_chapter_attendees_model.dart';
import 'package:resonate/features/stories/data/services/live_chapter_coordinator.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/ui_sizes.dart';

class LiveChapterAttendeeBlock extends ConsumerWidget {
  const LiveChapterAttendeeBlock({super.key, required this.user});

  final LiveChapterAttendee user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final model = ref.watch(liveChapterProvider).model;
    final isAuthorBlock = model?.authorUid == user.id;
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: UiSizes.height_2,
        horizontal: UiSizes.width_2,
      ),
      alignment: Alignment.center,
      child: Column(
        children: [
          CircleAvatar(
            radius: UiSizes.size_32,
            backgroundColor: colorScheme.primary,
            child: CircleAvatar(
              backgroundImage: NetworkImage(user.profileImageUrl ?? ''),
              radius: UiSizes.size_30,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  (user.name ?? '').split(' ').first,
                  style: TextStyle(fontSize: UiSizes.size_16),
                ),
              ],
            ),
          ),
          Text(
            isAuthorBlock
                ? AppLocalizations.of(context)!.author
                : AppLocalizations.of(context)!.listener,
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
              fontSize: UiSizes.size_14,
            ),
          ),
        ],
      ),
    );
  }
}
