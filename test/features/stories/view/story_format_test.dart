import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/stories/view/story_format.dart';

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
}
