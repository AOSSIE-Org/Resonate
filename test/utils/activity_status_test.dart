import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/utils/enums/activity_status.dart';

void main() {
  group('wire values', () {
    test('match the status enum on the users collection', () {
      expect(ActivityStatus.values.map((s) => s.wire), [
        'online',
        'dnd',
        'inroom',
        'invisible',
        'offline',
      ]);
    });

    test('round-trip through fromWire', () {
      for (final status in ActivityStatus.values) {
        expect(ActivityStatus.fromWire(status.wire), status);
      }
    });

    test('fromWire is null for unknown and missing values', () {
      expect(ActivityStatus.fromWire(null), isNull);
      expect(ActivityStatus.fromWire(''), isNull);
      expect(ActivityStatus.fromWire('busy'), isNull);
      // Casing matters — the server stores lowercase.
      expect(ActivityStatus.fromWire('DND'), isNull);
    });
  });

  group('blocksCalls', () {
    test('matches CALL_BLOCKING_STATUSES in start-friend-call', () {
      expect(
        ActivityStatus.values.where((s) => s.blocksCalls),
        [ActivityStatus.dnd, ActivityStatus.inRoom],
      );
    });

    test('invisible does not block calls', () {
      expect(ActivityStatus.invisible.blocksCalls, isFalse);
    });
  });

  group('asSeenByOthers', () {
    test('hides invisible behind offline', () {
      expect(ActivityStatus.invisible.asSeenByOthers, ActivityStatus.offline);
    });

    test('leaves every other status untouched', () {
      for (final status in ActivityStatus.values) {
        if (status == ActivityStatus.invisible) continue;
        expect(status.asSeenByOthers, status);
      }
    });
  });

  group('selectable', () {
    test('excludes the system-driven statuses', () {
      expect(ActivityStatus.selectable, [
        ActivityStatus.online,
        ActivityStatus.dnd,
        ActivityStatus.invisible,
      ]);
      expect(
        ActivityStatus.selectable,
        isNot(contains(ActivityStatus.inRoom)),
      );
      expect(
        ActivityStatus.selectable,
        isNot(contains(ActivityStatus.offline)),
      );
    });
  });
}
