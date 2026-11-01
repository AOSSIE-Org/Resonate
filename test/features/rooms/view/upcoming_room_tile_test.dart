import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/rooms/view/widgets/upcoming_room_tile.dart';
import 'package:resonate/features/rooms/data/upcoming_rooms.dart';
import 'package:resonate/utils/extensions/datetime_extension.dart';

import '../rooms_test_helpers.dart';

List<Override> _overridesWith(FakeUpcomingRooms fake) {
  return [upcomingRoomsProvider.overrideWith(() => fake)];
}

void main() {
  group('UpcomingListTile creator branch', () {
    testRoomsWidget('renders chat FAB, Cancel and Start', (tester) async {
      final fake = FakeUpcomingRooms();
      await pumpRoomsPage(
        tester,
        UpcomingListTile(
          appwriteUpcomingRoom: fakeUpcomingRoom(userIsCreator: true),
        ),
        overrides: _overridesWith(fake),
      );
      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.chat), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Start'), findsOneWidget);
      // Creator branch has no delete-from-list IconButton.
      expect(find.byIcon(Icons.delete_forever), findsNothing);
    });

    testRoomsWidget('Start is disabled and grey when isTime is false', (
      tester,
    ) async {
      final fake = FakeUpcomingRooms();
      await pumpRoomsPage(
        tester,
        UpcomingListTile(
          appwriteUpcomingRoom: fakeUpcomingRoom(
            userIsCreator: true,
            isTime: false,
          ),
        ),
        overrides: _overridesWith(fake),
      );
      await tester.pumpAndSettle();

      final startButton = tester.widget<ElevatedButton>(
        find.ancestor(
          of: find.text('Start'),
          matching: find.byType(ElevatedButton),
        ),
      );
      expect(startButton.onPressed, isNull);
    });

    testRoomsWidget('Start is enabled when isTime is true', (tester) async {
      final fake = FakeUpcomingRooms();
      await pumpRoomsPage(
        tester,
        UpcomingListTile(
          appwriteUpcomingRoom: fakeUpcomingRoom(
            userIsCreator: true,
            isTime: true,
          ),
        ),
        overrides: _overridesWith(fake),
      );
      await tester.pumpAndSettle();

      final startButton = tester.widget<ElevatedButton>(
        find.ancestor(
          of: find.text('Start'),
          matching: find.byType(ElevatedButton),
        ),
      );
      expect(startButton.onPressed, isNotNull);
    });

    testRoomsWidget('tapping Start calls convertToLive with room details', (
      tester,
    ) async {
      final fake = FakeUpcomingRooms();
      await pumpRoomsPage(
        tester,
        UpcomingListTile(
          appwriteUpcomingRoom: fakeUpcomingRoom(
            id: 'up-9',
            name: 'Morning Sync',
            description: 'Daily standup',
            tags: const ['work', 'sync'],
            userIsCreator: true,
            isTime: true,
          ),
        ),
        overrides: _overridesWith(fake),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Start'));
      await tester.pumpAndSettle();

      expect(fake.convertCount, 1);
      expect(fake.convertedId, 'up-9');
      expect(fake.convertedName, 'Morning Sync');
      expect(fake.convertedDescription, 'Daily standup');
      expect(fake.convertedTags, ['work', 'sync']);
    });

    testRoomsWidget('tapping Cancel calls deleteUpcoming with the id', (
      tester,
    ) async {
      final fake = FakeUpcomingRooms();
      await pumpRoomsPage(
        tester,
        UpcomingListTile(
          appwriteUpcomingRoom: fakeUpcomingRoom(
            id: 'up-5',
            userIsCreator: true,
          ),
        ),
        overrides: _overridesWith(fake),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(fake.deleteUpcomingCount, 1);
      expect(fake.deletedId, 'up-5');
    });
  });

  group('UpcomingListTile non-creator branch', () {
    testRoomsWidget('renders delete-from-list IconButton, chat FAB, Subscribe', (
      tester,
    ) async {
      final fake = FakeUpcomingRooms();
      await pumpRoomsPage(
        tester,
        UpcomingListTile(
          appwriteUpcomingRoom: fakeUpcomingRoom(
            userIsCreator: false,
            hasUserSubscribed: false,
          ),
        ),
        overrides: _overridesWith(fake),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.delete_forever), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.chat), findsOneWidget);
      expect(find.text('Subscribe'), findsOneWidget);
      // Not the creator controls.
      expect(find.text('Cancel'), findsNothing);
      expect(find.text('Start'), findsNothing);
    });

    testRoomsWidget('shows Unsubscribe label when already subscribed', (
      tester,
    ) async {
      final fake = FakeUpcomingRooms();
      await pumpRoomsPage(
        tester,
        UpcomingListTile(
          appwriteUpcomingRoom: fakeUpcomingRoom(
            userIsCreator: false,
            hasUserSubscribed: true,
          ),
        ),
        overrides: _overridesWith(fake),
      );
      await tester.pumpAndSettle();

      expect(find.text('Unsubscribe'), findsOneWidget);
      expect(find.text('Subscribe'), findsNothing);
    });

    testRoomsWidget('subscribe button color toggles on hasUserSubscribed', (
      tester,
    ) async {
      final fake = FakeUpcomingRooms();
      // Subscribed -> error (destructive) background.
      await pumpRoomsPage(
        tester,
        UpcomingListTile(
          appwriteUpcomingRoom: fakeUpcomingRoom(
            userIsCreator: false,
            hasUserSubscribed: true,
          ),
        ),
        overrides: _overridesWith(fake),
      );
      await tester.pumpAndSettle();

      final subBtn = tester.widget<ElevatedButton>(
        find.ancestor(
          of: find.text('Unsubscribe'),
          matching: find.byType(ElevatedButton),
        ),
      );
      final bg = subBtn.style!.backgroundColor!.resolve({});
      final expectedError = Theme.of(
        tester.element(find.text('Unsubscribe')),
      ).colorScheme.error;
      expect(bg, expectedError);
    });

    testRoomsWidget('tapping Subscribe calls subscribe with the id', (
      tester,
    ) async {
      final fake = FakeUpcomingRooms();
      await pumpRoomsPage(
        tester,
        UpcomingListTile(
          appwriteUpcomingRoom: fakeUpcomingRoom(
            id: 'up-1',
            userIsCreator: false,
            hasUserSubscribed: false,
          ),
        ),
        overrides: _overridesWith(fake),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Subscribe'));
      await tester.pumpAndSettle();

      expect(fake.subscribed, ['up-1']);
      expect(fake.unsubscribed, isEmpty);
    });

    testRoomsWidget('tapping Unsubscribe calls unsubscribe with the id', (
      tester,
    ) async {
      final fake = FakeUpcomingRooms();
      await pumpRoomsPage(
        tester,
        UpcomingListTile(
          appwriteUpcomingRoom: fakeUpcomingRoom(
            id: 'up-2',
            userIsCreator: false,
            hasUserSubscribed: true,
          ),
        ),
        overrides: _overridesWith(fake),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Unsubscribe'));
      await tester.pumpAndSettle();

      expect(fake.unsubscribed, ['up-2']);
      expect(fake.subscribed, isEmpty);
    });

    testRoomsWidget('delete_forever opens remove dialog; Hide calls hideLocally', (
      tester,
    ) async {
      final fake = FakeUpcomingRooms();
      await pumpRoomsPage(
        tester,
        UpcomingListTile(
          appwriteUpcomingRoom: fakeUpcomingRoom(
            id: 'up-7',
            userIsCreator: false,
          ),
        ),
        overrides: _overridesWith(fake),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete_forever));
      await tester.pumpAndSettle();

      // Dialog rendered with title + confirmation.
      expect(find.text('Remove Room'), findsOneWidget);
      expect(
        find.text(
          'Are you sure you want to remove this upcoming room from your list?',
        ),
        findsOneWidget,
      );

      // Confirm with the "Remove" (hide) action inside the dialog.
      await tester.tap(find.widgetWithText(TextButton, 'Remove'));
      await tester.pumpAndSettle();

      expect(fake.hideLocallyCount, 1);
      expect(fake.hiddenId, 'up-7');
    });
  });

  group('UpcomingListTile content', () {
    testRoomsWidget('renders the scheduled date/time string', (tester) async {
      final fake = FakeUpcomingRooms();
      final scheduled = DateTime(2025, 3, 4, 15, 30);
      await pumpRoomsPage(
        tester,
        UpcomingListTile(
          appwriteUpcomingRoom: fakeUpcomingRoom(
            scheduledDateTime: scheduled,
          ),
        ),
        overrides: _overridesWith(fake),
      );
      await tester.pumpAndSettle();

      final expected = scheduled.dateToLocalFormatted(const Locale('en'));
      expect(find.text(expected), findsOneWidget);
    });

    testRoomsWidget('renders up to 3 avatars when more are provided', (
      tester,
    ) async {
      final fake = FakeUpcomingRooms();
      await pumpRoomsPage(
        tester,
        UpcomingListTile(
          appwriteUpcomingRoom: fakeUpcomingRoom(
            subscribersAvatarUrls: const [
              'https://example.com/a.jpg',
              'https://example.com/b.jpg',
              'https://example.com/c.jpg',
              'https://example.com/d.jpg',
              'https://example.com/e.jpg',
            ],
          ),
        ),
        overrides: _overridesWith(fake),
      );
      await tester.pumpAndSettle();

      // Avatars are Containers with a DecorationImage; capped at 3.
      final avatars = tester
          .widgetList<Container>(find.byType(Container))
          .where((c) {
        final d = c.decoration;
        return d is BoxDecoration && d.image != null;
      });
      expect(avatars.length, 3);
    });
  });
}
