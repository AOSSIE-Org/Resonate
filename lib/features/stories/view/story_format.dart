import 'package:intl/intl.dart';
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
