import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:resonate/features/stories/data/repositories/stories_repository.dart';
import 'package:resonate/features/stories/viewmodel/create_story_notifier.dart';
import 'package:resonate/features/stories/viewmodel/live_chapter_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/ui_sizes.dart';

class VerifyChapterDetailsPage extends ConsumerStatefulWidget {
  const VerifyChapterDetailsPage({super.key, required this.lyricsString});
  final String lyricsString;

  @override
  ConsumerState<VerifyChapterDetailsPage> createState() =>
      _VerifyChapterDetailsPageState();
}

class _VerifyChapterDetailsPageState
    extends ConsumerState<VerifyChapterDetailsPage> {
  final titleController = TextEditingController();
  final aboutController = TextEditingController();
  final lyricsController = TextEditingController();
  File? chapterCoverImage;
  File? audioFile;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadInitialData());
  }

  @override
  void dispose() {
    titleController.dispose();
    aboutController.dispose();
    lyricsController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    final model = ref.read(liveChapterProvider).model;
    if (model == null) return;
    final storagePath = await getApplicationDocumentsDirectory();
    audioFile = File(
      "${storagePath.path}/recordings/${model.livekitRoomId}.wav",
    );
    titleController.text = model.chapterTitle;
    aboutController.text = model.chapterDescription;
    lyricsController.text = widget.lyricsString;
    setState(() {});
  }

  Future<void> _pickCoverImage() async {
    final selected = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (selected != null) {
      setState(() => chapterCoverImage = File(selected.path));
    }
  }

  Future<void> _viewOrEditLyrics() async {
    final l10n = AppLocalizations.of(context)!;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.viewOrEditLyrics),
        content: TextField(
          controller: lyricsController,
          maxLines: 10,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  Future<void> _createChapter() async {
    final l10n = AppLocalizations.of(context)!;
    final model = ref.read(liveChapterProvider).model;
    if (titleController.text.isEmpty ||
        aboutController.text.isEmpty ||
        audioFile == null ||
        model == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.error),
          content: Text(l10n.fillAllRequiredFields),
          actions: [
            TextButton(
              child: Text(l10n.ok),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
      return;
    }

    final router = GoRouter.of(context);
    final chapter = await ref
        .read(storiesRepositoryProvider)
        .buildRecordedChapter(
          chapterId: model.id,
          title: titleController.text,
          description: aboutController.text,
          coverImgPath:
              chapterCoverImage?.path ?? chapterCoverImagePlaceholderUrl,
          audioFilePath: audioFile!.path,
          lyrics: lyricsController.text,
        );
    await ref
        .read(createStoryProvider.notifier)
        .addChaptersToStory([chapter], model.storyId);

    ref.read(liveChapterProvider.notifier).reset();
    router.go(RoutePaths.tabview);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        final currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: colorScheme.surface,
        appBar: AppBar(title: Text(l10n.verifyChapterDetails)),
        body: Padding(
          padding: EdgeInsets.all(UiSizes.width_16),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                maxLines: 1,
                maxLength: 20,
                decoration: InputDecoration(
                  labelText: l10n.chapterTitle,
                  counterText: '',
                ),
              ),
              SizedBox(height: UiSizes.height_20),
              TextField(
                controller: aboutController,
                maxLength: 2000,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: l10n.aboutRequired,
                  counterText: '',
                ),
              ),
              SizedBox(height: UiSizes.height_20),
              _coverPicker(context),
              SizedBox(height: UiSizes.height_30),
              _infoTile(
                context,
                onTap: null,
                label: audioFile != null
                    ? l10n.audioFileSelected(audioFile!.path.split('/').last)
                    : l10n.uploadAudioFile,
              ),
              SizedBox(height: UiSizes.height_20),
              _infoTile(
                context,
                onTap: _viewOrEditLyrics,
                label: l10n.viewOrEditLyrics,
              ),
              SizedBox(height: UiSizes.height_40),
              ElevatedButton(
                onPressed: _createChapter,
                child: Text(l10n.createChapter),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _coverPicker(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(UiSizes.width_8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(UiSizes.width_20),
              child: chapterCoverImage != null
                  ? Image.file(
                      chapterCoverImage!,
                      fit: BoxFit.cover,
                      height: UiSizes.height_140,
                      width: UiSizes.height_140,
                    )
                  : Image.network(
                      chapterCoverImagePlaceholderUrl,
                      fit: BoxFit.cover,
                      height: UiSizes.height_140,
                      width: UiSizes.height_140,
                    ),
            ),
          ),
        ),
        SizedBox(width: UiSizes.width_10),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(UiSizes.width_8),
            child: GestureDetector(
              onTap: _pickCoverImage,
              child: Container(
                height: UiSizes.height_140,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha: 0.5),
                  ),
                  borderRadius: BorderRadius.circular(UiSizes.width_20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.change_circle,
                      size: UiSizes.size_40,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    Text(l10n.changeCoverImage, textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoTile(
    BuildContext context, {
    required VoidCallback? onTap,
    required String label,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: UiSizes.height_50,
        decoration: BoxDecoration(
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.6),
          ),
          borderRadius: BorderRadius.circular(UiSizes.width_8),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: UiSizes.width_8),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ),
        ),
      ),
    );
  }
}
