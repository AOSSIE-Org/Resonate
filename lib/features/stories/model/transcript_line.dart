import 'dart:convert';


class TranscriptLine {
  const TranscriptLine({required this.at, required this.text});

  final Duration at;
  final String text;
}

final _lrcLine = RegExp(r'^\[(\d{1,3}):(\d{1,2})\.(\d{1,3})\](.*)$');

List<TranscriptLine> parseTranscript(String transcript) {
  final lines = <TranscriptLine>[];
  for (final raw in const LineSplitter().convert(transcript)) {
    final match = _lrcLine.firstMatch(raw.trim());
    if (match == null) continue;
    final text = match.group(4)!.trim();
    if (text.isEmpty) continue;
    lines.add(
      TranscriptLine(
        at: Duration(
          minutes: int.parse(match.group(1)!),
          seconds: int.parse(match.group(2)!),
          milliseconds: int.parse(match.group(3)!),
        ),
        text: text,
      ),
    );
  }
  return lines;
}
