import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/rooms/data/live_rooms.dart';
import 'package:resonate/features/rooms/data/upcoming_rooms.dart';
import 'package:resonate/features/rooms/model/appwrite_room.dart';
import 'package:resonate/features/shell/view/pages/home_screen.dart';

import '../../rooms/rooms_test_helpers.dart';

void main() {
  // isLiveSelected is a file-level global shared with tabview_screen, so a test
  // that leaves it flipped would decide where the next one starts.
  setUp(() => isLiveSelected = true);
  tearDown(() => isLiveSelected = true);

  Future<void> pumpHome(
    WidgetTester tester, {
    List<AppwriteRoom> live = const [],
  }) async {
    await pumpTestApp(
      tester,
      const HomeScreen(),
      overrides: [
        requireUserProvider.overrideWithValue(fakeAuthUser(uid: 'me')),
        currentUserProvider.overrideWithValue(fakeAuthUser(uid: 'me')),
        liveRoomsProvider.overrideWith(() => FakeLiveRooms(rooms: live)),
        upcomingRoomsProvider.overrideWith(FakeUpcomingRooms.new),
      ],
    );
    await tester.pumpAndSettle();
  }

  group('swiping between Live and Upcoming', () {
    testAppWidget('a swipe left moves on to Upcoming', (tester) async {
      await pumpHome(tester, live: [fakeAppwriteRoom(name: 'Live One')]);
      expect(find.text('Live One'), findsOneWidget);

      await tester.drag(find.byType(PageView), const Offset(-400, 0));
      await tester.pumpAndSettle();

      expect(isLiveSelected, isFalse);
      expect(find.text('Live One'), findsNothing);
    });

    testAppWidget('a swipe back returns to Live', (tester) async {
      await pumpHome(tester, live: [fakeAppwriteRoom(name: 'Live One')]);

      await tester.drag(find.byType(PageView), const Offset(-400, 0));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(PageView), const Offset(400, 0));
      await tester.pumpAndSettle();

      expect(isLiveSelected, isTrue);
      expect(find.text('Live One'), findsOneWidget);
    });

    testAppWidget('tapping the header still switches, and agrees with the page', (
      tester,
    ) async {
      await pumpHome(tester, live: [fakeAppwriteRoom(name: 'Live One')]);

      await tester.tap(find.text('UPCOMING'));
      await tester.pumpAndSettle();

      expect(isLiveSelected, isFalse);
      expect(find.text('Live One'), findsNothing);

      await tester.tap(find.text('LIVE'));
      await tester.pumpAndSettle();

      expect(isLiveSelected, isTrue);
      expect(find.text('Live One'), findsOneWidget);
    });

    // tabview_screen sets the flag before switching back to this tab, which
    // rebuilds the screen from scratch: the ternary body unmounts it.
    testAppWidget('opens on Upcoming when the flag was set before mounting', (
      tester,
    ) async {
      isLiveSelected = false;

      await pumpHome(tester, live: [fakeAppwriteRoom(name: 'Live One')]);

      expect(find.text('Live One'), findsNothing);
    });
  });
}
