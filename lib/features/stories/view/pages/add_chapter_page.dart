import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/features/stories/model/chapter.dart';
import 'package:resonate/features/stories/view/pages/create_chapter_page.dart';
import 'package:resonate/features/stories/view/story_format.dart';
import 'package:resonate/features/stories/viewmodel/create_story_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/shared/widgets/snackbar.dart';

class AddChapterPage extends ConsumerStatefulWidget {
  final String storyName;
  final String storyId;
  final List<Chapter> currentChapters;

  const AddChapterPage({
    super.key,
    required this.storyName,
    required this.currentChapters,
    required this.storyId,
  });

  @override
  ConsumerState<AddChapterPage> createState() => _AddChapterPageState();
}

class _AddChapterPageState extends ConsumerState<AddChapterPage> {
  final List<Chapter> newChapters = [];

  void _onChapterCreated(Chapter chapter) =>
      setState(() => newChapters.add(chapter));

  Future<void> _submit() async {
    if (newChapters.isEmpty) return;
    final navigator = Navigator.of(context);
    final l10n = AppLocalizations.of(context)!;
    try {
      await ref
          .read(createStoryProvider.notifier)
          .addChaptersToStory(newChapters, widget.storyId);
      // Pop back past the add-chapter screen and the story screen
      navigator.pop();
      navigator.pop();
    } catch (e) {
      customSnackbar(l10n.error, e.toString(), LogType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final sectionStyle = TextStyle(
      fontSize: UiSizes.size_18,
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(title: Text(l10n.addNewChaptersToStory(widget.storyName))),
      body: Padding(
        padding: EdgeInsets.all(UiSizes.width_16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.currentChapters, style: sectionStyle),
            SizedBox(height: UiSizes.height_10),
            Expanded(
              child: ListView.builder(
                itemCount: widget.currentChapters.length,
                itemBuilder: (context, index) =>
                    _chapterCard(widget.currentChapters[index]),
              ),
            ),
            SizedBox(height: UiSizes.height_10),
            Text(l10n.newChapters, style: sectionStyle),
            SizedBox(height: UiSizes.height_10),
            Expanded(
              child: ListView.builder(
                itemCount: newChapters.length,
                itemBuilder: (context, index) =>
                    _chapterCard(newChapters[index]),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(vertical: UiSizes.height_16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      CreateChapterPage(onChapterCreated: _onChapterCreated),
                ),
              ),
              child: const Icon(Icons.add),
            ),
            SizedBox(height: UiSizes.height_20),
            ElevatedButton(onPressed: _submit, child: Text(l10n.newChapters)),
          ],
        ),
      ),
    );
  }

  Widget _chapterCard(Chapter chapter) {
    final isLocalFile = chapter.coverImageUrl.startsWith('/');
    return Card(
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(UiSizes.width_5),
          child: isLocalFile
              ? Image.file(
                  File(chapter.coverImageUrl),
                  width: UiSizes.width_56,
                  height: UiSizes.width_56,
                  fit: BoxFit.cover,
                )
              : Image.network(
                  chapter.coverImageUrl,
                  width: UiSizes.width_56,
                  height: UiSizes.width_56,
                  fit: BoxFit.cover,
                ),
        ),
        title: Text(chapter.title),
        subtitle: Text(
          chapter.description.length > 30
              ? '${chapter.description.substring(0, 30)}...'
              : chapter.description,
        ),
        trailing: Text(formatPlayDuration(chapter.playDuration)),
      ),
    );
  }
}
