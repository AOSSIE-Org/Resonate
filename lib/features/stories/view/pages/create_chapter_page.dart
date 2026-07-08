import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resonate/features/stories/model/chapter.dart';
import 'package:resonate/features/stories/view/widgets/cover_image_picker.dart';
import 'package:resonate/features/stories/viewmodel/create_story_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/enums/audio_format.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/utils/enums/lyrics_format.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/views/widgets/snackbar.dart';

class CreateChapterPage extends ConsumerStatefulWidget {
  const CreateChapterPage({super.key, required this.onChapterCreated});

  final void Function(Chapter) onChapterCreated;

  @override
  ConsumerState<CreateChapterPage> createState() => _CreateChapterPageState();
}

class _CreateChapterPageState extends ConsumerState<CreateChapterPage> {
  final titleController = TextEditingController();
  final aboutController = TextEditingController();
  File? chapterCoverImage;
  File? audioFile;
  File? lyricsFile;

  @override
  void dispose() {
    titleController.dispose();
    aboutController.dispose();
    super.dispose();
  }

  Future<void> _pickCoverImage() async {
    final selected = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (selected != null) {
      setState(() => chapterCoverImage = File(selected.path));
    }
  }

  Future<void> _pickAudioFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: AudioFormat.extensions,
    );
    if (!mounted) return;
    final file = result?.files.single;
    if (file == null) return;
    if (!_hasAllowedExtension(file, AudioFormat.extensions)) {
      _showFormatError(AudioFormat.extensions);
      return;
    }
    setState(() => audioFile = File(file.path!));
  }

  Future<void> _pickLyricsFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (!mounted) return;
    final file = result?.files.single;
    if (file == null) return;
    if (!_hasAllowedExtension(file, LyricsFormat.extensions)) {
      _showFormatError(LyricsFormat.extensions);
      return;
    }
    setState(() => lyricsFile = File(file.path!));
  }

  bool _hasAllowedExtension(PlatformFile file, List<String> allowed) {
    final ext = file.extension?.toLowerCase();
    return ext != null && allowed.contains(ext);
  }

  void _showFormatError(List<String> allowed) {
    customSnackbar(
      AppLocalizations.of(context)!.invalidFormat,
      allowed.map((e) => '.$e').join(', '),
      LogType.error,
    );
  }

  Future<void> _createChapter() async {
    final l10n = AppLocalizations.of(context)!;
    if (titleController.text.isEmpty ||
        aboutController.text.isEmpty ||
        audioFile == null) {
      customSnackbar(l10n.error, l10n.fillAllRequiredFields, LogType.error);
      return;
    }

    final navigator = Navigator.of(context);
    final chapter = await ref
        .read(createStoryProvider.notifier)
        .buildChapter(
          title: titleController.text,
          description: aboutController.text,
          coverImgPath:
              chapterCoverImage?.path ?? chapterCoverImagePlaceholderUrl,
          audioFilePath: audioFile!.path,
          lyricsFilePath: lyricsFile?.path ?? '',
        );

    widget.onChapterCreated(chapter);
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: colorScheme.surface,
        appBar: AppBar(title: Text(l10n.createAChapter)),
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
              CoverImagePicker(
                image: chapterCoverImage,
                placeholderUrl: chapterCoverImagePlaceholderUrl,
                onTap: _pickCoverImage,
              ),
              SizedBox(height: UiSizes.height_30),
              _filePicker(
                context,
                onTap: _pickAudioFile,
                label: audioFile != null
                    ? l10n.audioFileSelected(audioFile!.path.split('/').last)
                    : l10n.uploadAudioFile,
              ),
              SizedBox(height: UiSizes.height_20),
              _filePicker(
                context,
                onTap: _pickLyricsFile,
                label: lyricsFile != null
                    ? l10n.lyricsFileSelected(lyricsFile!.path.split('/').last)
                    : l10n.uploadLyricsFile,
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

  Widget _filePicker(
    BuildContext context, {
    required VoidCallback onTap,
    required String label,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: UiSizes.height_50,
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.outline.withValues(alpha: 0.6)),
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
