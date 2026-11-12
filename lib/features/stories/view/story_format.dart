import 'package:intl/intl.dart';
import 'package:resonate/features/stories/model/stories_failure.dart';
import 'package:resonate/l10n/app_localizations.dart';

String formatPlayDuration(int milliseconds) {
  final totalSeconds = (milliseconds / 1000).round();
  final minutes = totalSeconds ~/ 60;
  final seconds = totalSeconds % 60;
  return "$minutes:${seconds.toString().padLeft(2, '0')}";
}

String formatChapterLength(int milliseconds, AppLocalizations l10n) =>
    '${formatPlayDuration(milliseconds)} ${l10n.lengthMinutes}';


String fileNameOf(String path) => path.split(RegExp(r'[/\\]')).last;

String formatRecordedAt(DateTime recordedAt) =>
    DateFormat.yMMMd().add_jm().format(recordedAt.toLocal());

String storiesFailureMessage(Object error, AppLocalizations l10n) =>
    switch (error) {
      StoriesFailureTooLarge(:final what, :final bytes, :final maxBytes) =>
        l10n.fileTooLarge(what, formatMegabytes(bytes), formatMegabytes(maxBytes)),
      StoriesFailureUpload(:final what) => l10n.uploadFailed(what),
      StoriesFailureUnknown(:final message) => message,
      _ => error.toString(),
    };

String formatMegabytes(int bytes) =>
    '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
