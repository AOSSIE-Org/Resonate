import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:resonate/features/stories/model/stories_failure.dart';
import 'package:resonate/features/stories/view/story_format.dart';
import 'package:resonate/l10n/app_localizations.dart';

void main() {
  group('formatPlayDuration', () {
    test('formats a sub-minute duration with zero-padded seconds', () {
      expect(formatPlayDuration(5000), '0:05');
      expect(formatPlayDuration(65000), '1:05');
    });

    test('rounds milliseconds to the nearest second', () {
      expect(formatPlayDuration(65400), '1:05');
      expect(formatPlayDuration(65600), '1:06');
    });

    test('handles zero and multi-minute durations', () {
      expect(formatPlayDuration(0), '0:00');
      expect(formatPlayDuration(600000), '10:00');
    });
  });

  group('formatRecordedAt', () {
    test('renders a stored UTC timestamp in local time', () {
      final utc = DateTime.utc(2026, 3, 4, 10, 30);

      expect(formatRecordedAt(utc), contains('2026'));
      expect(
        formatRecordedAt(utc),
        contains(DateFormat.jm().format(utc.toLocal())),
      );
    });
  });

  group('storiesFailureMessage', () {
    late AppLocalizations l10n;

    setUp(() async {
      l10n = await AppLocalizations.delegate.load(const Locale('en'));
    });

    test('an oversized file names its own size and the limit', () {
      final message = storiesFailureMessage(
        const StoriesFailure.tooLarge('story cover', 16676789, 5 * 1024 * 1024),
        l10n,
      );

      expect(message, contains('story cover'));
      expect(message, contains('15.9 MB'));
      expect(message, contains('5.0 MB'));
    });

    test('an upload failure reads as a sentence, not a toString', () {
      final message = storiesFailureMessage(
        const StoriesFailure.upload('chapter cover'),
        l10n,
      );

      expect(message, contains('chapter cover'));
      expect(message, isNot(contains('StoriesFailure')));
    });

    test('an unknown failure passes its message through', () {
      final message = storiesFailureMessage(
        const StoriesFailure.unknown('the server said no'),
        l10n,
      );

      expect(message, 'the server said no');
    });

    test('anything else falls back to its own string', () {
      final message = storiesFailureMessage(StateError('boom'), l10n);

      expect(message, contains('boom'));
    });
  });
}
