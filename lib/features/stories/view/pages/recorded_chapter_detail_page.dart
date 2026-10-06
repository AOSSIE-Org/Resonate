import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/features/stories/model/recorded_chapter.dart';
import 'package:resonate/features/stories/model/transcript_line.dart';
import 'package:resonate/features/stories/view/story_format.dart';
import 'package:resonate/features/stories/view/widgets/recorded_chapter_tile.dart';
import 'package:resonate/features/stories/viewmodel/recorded_chapters_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/shared/widgets/snackbar.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/utils/utils.dart';

class RecordedChapterDetailPage extends ConsumerWidget {
  const RecordedChapterDetailPage({super.key, required this.chapter});

  final RecordedChapter chapter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final description = chapter.description.trim();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(title: Text(recordedChapterTitle(chapter, l10n))),
      body: ListView(
        padding: EdgeInsets.all(UiSizes.width_16),
        children: [
          _Section(
            child: Column(
              children: [
                _DetailRow(
                  label: l10n.recordedOn,
                  value: formatRecordedAt(chapter.recordedAt),
                ),
                _DetailRow(
                  label: l10n.recordingLength,
                  value: formatChapterLength(chapter.durationMs, l10n),
                ),
                _DetailRow(
                  label: l10n.audioFile,
                  value: fileNameOf(chapter.audioFilePath),
                ),
              ],
            ),
          ),
          if (description.isNotEmpty) ...[
            SizedBox(height: UiSizes.height_16),
            _Section(
              title: l10n.about,
              child: Text(
                description,
                style: TextStyle(
                  fontSize: UiSizes.size_16,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ],
          SizedBox(height: UiSizes.height_16),
          _Section(
            title: l10n.transcript,
            child: _Transcript(transcript: chapter.transcript),
          ),
          SizedBox(height: UiSizes.height_30),
          ElevatedButton.icon(
            onPressed: () => _confirmDelete(context, ref),
            icon: const Icon(Icons.delete_outline_rounded),
            label: Text(l10n.deleteRecording),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
              minimumSize: Size.fromHeight(UiSizes.height_50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(UiSizes.width_16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    AppUtils.showDialog(
      context: context,
      title: l10n.areYouSure,
      middleText: l10n.deleteRecordingMessage,
      firstBtnText: l10n.deleteRecording,
      onFirstBtnPressed: () {
        Navigator.of(context).pop();
        _delete(context, ref);
      },
      onSecondBtnPressed: () => Navigator.of(context).pop(),
    );
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final title = recordedChapterTitle(chapter, l10n);
    final notifier = ref.read(recordedChaptersProvider.notifier);
    Navigator.of(context).pop();
    try {
      await notifier.delete(chapter.id);
      customSnackbar(l10n.recordingDeleted, title, LogType.success);
    } catch (e) {
      customSnackbar(l10n.deleteRecordingFailed, e.toString(), LogType.error);
    }
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.child, this.title});

  final Widget child;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(UiSizes.width_16),
      decoration: BoxDecoration(
        color: colorScheme.secondary,
        borderRadius: BorderRadius.circular(UiSizes.width_16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: TextStyle(
                fontSize: UiSizes.size_17,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: UiSizes.height_10),
          ],
          child,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: UiSizes.height_5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: UiSizes.width_100,
            child: Text(
              label,
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Transcript extends StatelessWidget {
  const _Transcript({required this.transcript});

  final String transcript;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final lines = parseTranscript(transcript);

    if (lines.isEmpty) {
      return Text(
        l10n.noTranscript,
        style: TextStyle(color: colorScheme.onSurfaceVariant),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final line in lines)
          Padding(
            padding: EdgeInsets.only(bottom: UiSizes.height_10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: UiSizes.width_56,
                  child: Text(
                    formatPlayDuration(line.at.inMilliseconds),
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: UiSizes.size_14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    line.text,
                    style: TextStyle(
                      fontSize: UiSizes.size_16,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
