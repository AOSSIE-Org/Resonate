import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/live_audio/data/speaking_throttle.dart';

void main() {
  const interval = Duration(milliseconds: 40);

  late List<String> published;
  late LeadingEdgeThrottle<String> throttle;

  setUp(() {
    published = [];
    throttle = LeadingEdgeThrottle<String>(
      interval: interval,
      publish: published.add,
    );
    addTearDown(throttle.cancel);
  });

  Future<void> waitInterval() => Future<void>.delayed(interval * 2);

  test('publishes the first value immediately', () {
    throttle.submit('a');
    expect(published, ['a']);
  });

  test('coalesces a burst into one trailing publish of the newest value', () async {
    throttle.submit('a');
    throttle.submit('b');
    throttle.submit('c');
    throttle.submit('d');
    expect(published, ['a']);

    await waitInterval();

    expect(published, ['a', 'd']);
  });

  test('returns to publishing immediately after a quiet spell', () async {
    throttle.submit('a');
    await waitInterval();
    // Nothing arrived during the window, so the throttle must have gone idle
    // rather than staying armed — otherwise this would wait out a tick.
    throttle.submit('b');

    expect(published, ['a', 'b']);
  });

  test('exposes the pending value so callers can accumulate in place', () async {
    throttle.submit('a');
    expect(throttle.pending, isNull, reason: 'published, nothing pending');

    throttle.submit('b');
    expect(throttle.pending, 'b');

    await waitInterval();
    expect(throttle.pending, isNull);
  });

  test('cancel drops anything still pending', () async {
    throttle.submit('a');
    throttle.submit('b');
    throttle.cancel();
    await waitInterval();

    expect(published, ['a']);
  });
}
