import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:resonate/features/stories/model/story.dart';
import 'package:resonate/features/stories/viewmodel/live_chapter_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/views/widgets/snackbar.dart';

class StartLiveChapterDialog extends ConsumerStatefulWidget {
  const StartLiveChapterDialog({super.key, required this.story});

  final Story story;

  @override
  ConsumerState<StartLiveChapterDialog> createState() =>
      _StartLiveChapterDialogState();
}

class _StartLiveChapterDialogState
    extends ConsumerState<StartLiveChapterDialog> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  bool _isStarting = false;

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    final l10n = AppLocalizations.of(context)!;
    final chapterName = nameController.text.trim();
    final chapterDescription = descriptionController.text.trim();

    if (chapterName.isEmpty || chapterDescription.isEmpty) {
      customSnackbar(l10n.error, l10n.fillAllFields, LogType.error);
      return;
    }

    setState(() => _isStarting = true);
    final navigator = Navigator.of(context);
    final router = GoRouter.of(context);
    try {
      await ref
          .read(liveChapterProvider.notifier)
          .startLiveChapter(
            roomId: ID.unique(),
            chapterTitle: chapterName,
            chapterDescription: chapterDescription,
            storyId: widget.story.storyId,
            storyName: widget.story.title,
          );
    } catch (e) {
      if (mounted) setState(() => _isStarting = false);
      log('startLiveChapter failed: $e');
      final message = e is AppwriteException
          ? (e.message ?? e.toString())
          : e.toString();
      customSnackbar(l10n.error, message, LogType.error);
      return;
    }
    navigator.pop();
    router.push(RoutePaths.liveChapterScreen);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(UiSizes.width_8),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(UiSizes.width_8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: UiSizes.height_5,
              children: [
                Text(
                  l10n.startLiveChapter,
                  style: TextStyle(
                    fontSize: UiSizes.size_18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFormField(
                  controller: nameController,
                  maxLines: 1,
                  maxLength: 20,
                  decoration: InputDecoration(hintText: l10n.chapterTitle),
                ),
                TextFormField(
                  controller: descriptionController,
                  maxLines: 3,
                  maxLength: 2000,
                  decoration: InputDecoration(hintText: l10n.description),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _isStarting
                          ? null
                          : () => Navigator.of(context).pop(),
                      child: Text(l10n.cancel),
                    ),
                    ElevatedButton(
                      onPressed: _isStarting ? null : _start,
                      child: _isStarting
                          ? SizedBox(
                              height: UiSizes.size_18,
                              width: UiSizes.size_18,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : Text(l10n.start),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
