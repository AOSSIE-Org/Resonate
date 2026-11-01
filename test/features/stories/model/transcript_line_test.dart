import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/stories/model/transcript_line.dart';

void main() {
  group('parseTranscript', () {
    test('reads back what the transcription service writes', () {
      final lines = parseTranscript(
        '[re:Resonate App - AOSSIE]\n'
        '[ve:v1.0.0]\n'
        '[00:00.000]Good evening\n'
        '[01:05.500]and welcome back\n',
      );

      expect(lines.map((line) => line.text), [
        'Good evening',
        'and welcome back',
      ]);
      expect(lines.first.at, Duration.zero);
      expect(
        lines.last.at,
        const Duration(minutes: 1, seconds: 5, milliseconds: 500),
      );
    });

    test('drops the header lines and anything unrecognised', () {
      final lines = parseTranscript(
        '[re:Resonate App - AOSSIE]\n'
        'Transcription Failed\n'
        '\n'
        '[00:01.000]only this one\n',
      );

      expect(lines, hasLength(1));
      expect(lines.single.text, 'only this one');
    });

    test('drops a timestamp with no words behind it', () {
      expect(parseTranscript('[00:01.000]   \n'), isEmpty);
    });

    test('an empty transcript parses to nothing', () {
      expect(parseTranscript(''), isEmpty);
      expect(parseTranscript('   '), isEmpty);
    });

    test('keeps minutes past the hour mark', () {
      final lines = parseTranscript('[75:03.000]still going\n');

      expect(lines.single.at, const Duration(minutes: 75, seconds: 3));
    });
  });
}
