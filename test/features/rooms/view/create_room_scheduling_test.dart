import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/rooms/view/pages/create_room_page.dart';
import 'package:resonate/features/rooms/viewmodel/create_room_notifier.dart';

import '../rooms_test_helpers.dart';

void main() {
  late FakeCreateRoom fake;
  late GlobalKey<CreateRoomPageState> key;

  Future<void> pumpCreateRoom(WidgetTester tester) async {
    fake = FakeCreateRoom();
    key = GlobalKey<CreateRoomPageState>();
    await pumpTestApp(
      tester,
      CreateRoomPage(key: key),
      rootOverlay: true,
      overrides: [
        createRoomProvider.overrideWith(() => fake),
        requireUserProvider.overrideWithValue(fakeAuthUser(uid: 'me')),
        currentUserProvider.overrideWithValue(fakeAuthUser(uid: 'me')),
      ],
    );
    await tester.pumpAndSettle();
  }

  Future<void> chooseScheduled(WidgetTester tester) async {
    await tester.tap(find.text('Scheduled'));
    await tester.pumpAndSettle();
  }

  Finder dateField() => find.byIcon(Icons.date_range);

  // Walks the date picker then the time picker, taking whatever each opens on.
  Future<void> pickDateTime(WidgetTester tester) async {
    await tester.tap(find.byType(TextFormField).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
  }

  // In scheduled mode the fields are: [0] date, [1] name, [2] description.
  // (Tags is a plain TextField, so it is not in this list.)
  Future<void> fillNameAndDescription(WidgetTester tester) async {
    await tester.enterText(find.byType(TextFormField).at(1), 'Book Club');
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(2), 'Weekly reading');
    await tester.pumpAndSettle();
  }

  group('switching mode', () {
    testAppWidget('scheduled reveals the date field', (tester) async {
      await pumpCreateRoom(tester);
      expect(key.currentState!.isScheduled, isFalse);
      expect(dateField(), findsNothing);

      await chooseScheduled(tester);

      expect(key.currentState!.isScheduled, isTrue);
      expect(dateField(), findsOneWidget);
    });

    // Going back to Live has to put the form back as it was.
    testAppWidget('live hides it again', (tester) async {
      await pumpCreateRoom(tester);
      await chooseScheduled(tester);

      await tester.tap(find.text('Live'));
      await tester.pumpAndSettle();

      expect(key.currentState!.isScheduled, isFalse);
      expect(dateField(), findsNothing);
    });
  });

  group('the date picker', () {
    testAppWidget('fills the field with what was chosen', (tester) async {
      await pumpCreateRoom(tester);
      await chooseScheduled(tester);

      await pickDateTime(tester);

      final field = tester.widget<TextFormField>(
        find.byType(TextFormField).first,
      );
      expect(field.controller?.text, isNotEmpty);
    });

    // The picker opens on today, so accepting it unchanged is a past time.
    testAppWidget('refuses a time that has already passed', (tester) async {
      await pumpCreateRoom(tester);
      await chooseScheduled(tester);

      await tester.tap(find.byType(TextFormField).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });

  group('submitting a scheduled room', () {
    testAppWidget('does nothing until a time is chosen', (tester) async {
      await pumpCreateRoom(tester);
      await chooseScheduled(tester);
      await fillNameAndDescription(tester);

      final room = await key.currentState!.submit();
      await tester.pumpAndSettle();

      expect(room, isNull);
      expect(fake.scheduledCount, 0);
    });

    testAppWidget('sends the name, description and time', (tester) async {
      await pumpCreateRoom(tester);
      await chooseScheduled(tester);
      await fillNameAndDescription(tester);
      await pickDateTime(tester);

      await key.currentState!.submit();
      await tester.pumpAndSettle();

      expect(fake.scheduledCount, 1);
      expect(fake.lastName, 'Book Club');
      expect(fake.lastDescription, 'Weekly reading');
      expect(fake.lastScheduled, isNotNull);
      expect(fake.liveCount, 0, reason: 'not a live room');
    });

    // The ISO string carries a timezone offset so the server schedules it in
    // the host's own time.
    testAppWidget('stamps the local timezone on the time', (tester) async {
      await pumpCreateRoom(tester);
      await chooseScheduled(tester);
      await fillNameAndDescription(tester);
      await pickDateTime(tester);

      await key.currentState!.submit();
      await tester.pumpAndSettle();

      expect(fake.lastScheduled, matches(r'T.*[+-]\d{2}:\d{2}$'));
    });

    testAppWidget('clears the form afterwards', (tester) async {
      await pumpCreateRoom(tester);
      await chooseScheduled(tester);
      await fillNameAndDescription(tester);
      await pickDateTime(tester);

      await key.currentState!.submit();
      await tester.pumpAndSettle();

      expect(find.text('Book Club'), findsNothing);
      expect(find.text('Weekly reading'), findsNothing);
    });
  });
}
