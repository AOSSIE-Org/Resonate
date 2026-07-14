import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/rooms/view/pages/create_room_page.dart';
import 'package:resonate/features/rooms/viewmodel/create_room_notifier.dart';

import '../rooms_test_helpers.dart';

List<Override> buildOverrides(FakeCreateRoom fake) {
  return [
    createRoomProvider.overrideWith(() => fake),
    requireUserProvider.overrideWithValue(fakeAuthUser(uid: 'me')),
    currentUserProvider.overrideWithValue(fakeAuthUser(uid: 'me')),
  ];
}

void main() {
  group('CreateRoomPage render', () {
    testRoomsWidget('renders Live and Scheduled mode chips', (tester) async {
      final fake = FakeCreateRoom();
      await pumpRoomsPage(
        tester,
        CreateRoomPage(key: GlobalKey<CreateRoomPageState>()),
        overrides: buildOverrides(fake),
      );
      await tester.pumpAndSettle();

      expect(find.text('Live'), findsOneWidget);
      expect(find.text('Scheduled'), findsOneWidget);
      expect(find.text('Create New Room'), findsOneWidget);
    });

    testRoomsWidget('tapping Scheduled toggles isScheduled and reveals the '
        'date/time field', (tester) async {
      final key = GlobalKey<CreateRoomPageState>();
      final fake = FakeCreateRoom();
      await pumpRoomsPage(
        tester,
        CreateRoomPage(key: key),
        overrides: buildOverrides(fake),
      );
      await tester.pumpAndSettle();

      // Live is default: no date-time field yet.
      expect(key.currentState!.isScheduled, isFalse);
      expect(find.text('Schedule Date Time'), findsNothing);

      await tester.tap(find.text('Scheduled'));
      await tester.pumpAndSettle();

      expect(key.currentState!.isScheduled, isTrue);
      expect(find.text('Schedule Date Time'), findsOneWidget);
      expect(find.byIcon(Icons.calendar_month), findsOneWidget);
    });

    testRoomsWidget('loading overlay shows when createRoomProvider is true', (
      tester,
    ) async {
      final fake = FakeCreateRoom(loading: true);
      await pumpRoomsPage(
        tester,
        CreateRoomPage(key: GlobalKey<CreateRoomPageState>()),
        overrides: buildOverrides(fake),
      );
      await tester.pump();

      expect(find.byType(BackdropFilter), findsOneWidget);
    });

    testRoomsWidget('no loading overlay when createRoomProvider is false', (
      tester,
    ) async {
      final fake = FakeCreateRoom();
      await pumpRoomsPage(
        tester,
        CreateRoomPage(key: GlobalKey<CreateRoomPageState>()),
        overrides: buildOverrides(fake),
      );
      await tester.pumpAndSettle();

      expect(find.byType(BackdropFilter), findsNothing);
    });
  });

  group('CreateRoomPage submit', () {
    testRoomsWidget('invalid form returns without calling the notifier', (
      tester,
    ) async {
      final key = GlobalKey<CreateRoomPageState>();
      final fake = FakeCreateRoom();
      await pumpRoomsPage(
        tester,
        CreateRoomPage(key: key),
        overrides: buildOverrides(fake),
      );
      await tester.pumpAndSettle();

      // Switch to scheduled so the empty date-time field fails validation.
      await tester.tap(find.text('Scheduled'));
      await tester.pumpAndSettle();

      final result = await key.currentState!.submit();
      await tester.pumpAndSettle();

      expect(result, isNull);
      expect(fake.liveCount, 0);
      expect(fake.scheduledCount, 0);
    });

    testRoomsWidget('live mode submit calls createLiveRoom and clears', (
      tester,
    ) async {
      final key = GlobalKey<CreateRoomPageState>();
      final fake = FakeCreateRoom();
      await pumpRoomsPage(
        tester,
        CreateRoomPage(key: key),
        overrides: buildOverrides(fake),
      );
      await tester.pumpAndSettle();

      // Name field is the first TextFormField; fill it so the form validates.
      await tester.enterText(find.byType(TextFormField).first, 'My Room');
      await tester.pumpAndSettle();

      final result = await key.currentState!.submit();
      await tester.pumpAndSettle();

      expect(fake.liveCount, 1);
      expect(fake.scheduledCount, 0);
      expect(fake.lastName, 'My Room');
      expect(result, isNotNull);
      // Cleared after success.
      expect(find.text('My Room'), findsNothing);
    });

    testRoomsWidget('scheduled submit with null iso returns null without '
        'calling notifier', (tester) async {
      final key = GlobalKey<CreateRoomPageState>();
      final fake = FakeCreateRoom();
      await pumpRoomsPage(
        tester,
        CreateRoomPage(key: key),
        overrides: buildOverrides(fake),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Scheduled'));
      await tester.pumpAndSettle();

      final dateField = find.byType(TextFormField).first;
      await tester.enterText(dateField, 'placeholder');
      await tester.pumpAndSettle();

      final result = await key.currentState!.submit();
      await tester.pumpAndSettle();

      expect(result, isNull);
      expect(fake.scheduledCount, 0);
      expect(fake.liveCount, 0);
    });

    testRoomsWidget('submit failure shows failedToCreateRoom snackbar', (
      tester,
    ) async {
      final key = GlobalKey<CreateRoomPageState>();
      final fake = FakeCreateRoom(throwOnCreate: true);
      await pumpRoomsPage(
        tester,
        CreateRoomPage(key: key),
        overrides: buildOverrides(fake),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, 'My Room');
      await tester.pumpAndSettle();

      final result = await key.currentState!.submit();
      await tester.pump(); // let the snackbar appear

      expect(fake.liveCount, 1);
      expect(result, isNull);
      expect(find.text('Failed to create room'), findsOneWidget);
    });
  });

  group('CreateRoomPage tag validation', () {
    test('isValidTag accepts and rejects the expected tags', () {
      // _validateTag delegates to the isValidTag extension.
      expect('goodtag'.isValidTag, isTrue);
      expect('good_tag1'.isValidTag, isTrue);
      expect('bad tag'.isValidTag, isFalse); // space
      expect('bad-tag'.isValidTag, isFalse); // hyphen
      expect('_leading'.isValidTag, isFalse); // must start alnum
      expect(('a' * 31).isValidTag, isFalse); // too long
    });
  });
}
