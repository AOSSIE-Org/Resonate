import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/rooms/data/live_rooms.dart';
import 'package:resonate/features/rooms/data/upcoming_rooms.dart';
import 'package:resonate/features/rooms/model/appwrite_room.dart';
import 'package:resonate/features/rooms/model/appwrite_upcoming_room.dart';
import 'package:resonate/features/shell/view/pages/home_screen.dart';

import '../../rooms/rooms_test_helpers.dart';


class _SeededUpcomingRooms extends UpcomingRoomsNotifier {
  _SeededUpcomingRooms(this.seed);

  final List<AppwriteUpcomingRoom> seed;
  int refreshCount = 0;

  @override
  Future<List<AppwriteUpcomingRoom>> build() async => seed;

  @override
  Future<void> refresh() async => refreshCount++;
}

void main() {
  setUp(() => isLiveSelected = true);
  tearDown(() => isLiveSelected = true);

  late FakeLiveRooms liveRooms;
  late _SeededUpcomingRooms upcomingRooms;

  Future<void> pumpHome(
    WidgetTester tester, {
    List<AppwriteRoom> live = const [],
    List<AppwriteUpcomingRoom> upcoming = const [],
  }) async {
    liveRooms = FakeLiveRooms(rooms: live);
    upcomingRooms = _SeededUpcomingRooms(upcoming);
    await pumpTestApp(
      tester,
      const HomeScreen(),
      overrides: [
        requireUserProvider.overrideWithValue(fakeAuthUser(uid: 'me')),
        currentUserProvider.overrideWithValue(fakeAuthUser(uid: 'me')),
        liveRoomsProvider.overrideWith(() => liveRooms),
        upcomingRoomsProvider.overrideWith(() => upcomingRooms),
      ],
    );
    await tester.pumpAndSettle();
  }

  Future<void> openSearch(WidgetTester tester) async {
    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();
  }

  Future<void> closeSearch(WidgetTester tester) async {
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  }

  Future<void> type(WidgetTester tester, String query) async {
    await tester.enterText(find.byType(TextField), query);
    await tester.pumpAndSettle();
  }

  group('searching live rooms', () {
    final rooms = [
      fakeAppwriteRoom(id: 'r1', name: 'Flutter Talk', description: 'widgets'),
      fakeAppwriteRoom(id: 'r2', name: 'Morning Jazz', description: 'music'),
    ];

    testAppWidget('the overlay is closed until the search icon is tapped', (
      tester,
    ) async {
      await pumpHome(tester, live: rooms);

      expect(find.byType(TextField), findsNothing);

      await openSearch(tester);

      expect(find.byType(TextField), findsOneWidget);
    });

    testAppWidget('a query narrows the list by name', (tester) async {
      await pumpHome(tester, live: rooms);
      await openSearch(tester);

      await type(tester, 'flutter');

      expect(find.text('Flutter Talk'), findsOneWidget);
      expect(find.text('Morning Jazz'), findsNothing);
    });

    // The description is searched too, so a room whose title gives nothing
    // away is still findable.
    testAppWidget('a query also matches the description', (tester) async {
      await pumpHome(tester, live: rooms);
      await openSearch(tester);

      await type(tester, 'music');

      expect(find.text('Morning Jazz'), findsOneWidget);
      expect(find.text('Flutter Talk'), findsNothing);
    });

    testAppWidget('matching ignores case', (tester) async {
      await pumpHome(tester, live: rooms);
      await openSearch(tester);

      await type(tester, 'FLUTTER');

      expect(find.text('Flutter Talk'), findsOneWidget);
    });

    testAppWidget('a query that matches nothing says so', (tester) async {
      await pumpHome(tester, live: rooms);
      await openSearch(tester);

      await type(tester, 'zzzz');

      expect(find.text('Flutter Talk'), findsNothing);
      expect(find.text('Morning Jazz'), findsNothing);
      expect(find.text('No Search Results'), findsOneWidget);
    });

    // An empty box is not a failed search, so the full list comes back
    // rather than the empty state.
    testAppWidget('clearing the box restores the whole list', (tester) async {
      await pumpHome(tester, live: rooms);
      await openSearch(tester);
      await type(tester, 'flutter');

      await type(tester, '');

      expect(find.text('Flutter Talk'), findsOneWidget);
      expect(find.text('Morning Jazz'), findsOneWidget);
      expect(find.text('No Search Results'), findsNothing);
    });

    testAppWidget('closing the overlay drops the filter', (tester) async {
      await pumpHome(tester, live: rooms);
      await openSearch(tester);
      await type(tester, 'flutter');
      expect(find.text('Morning Jazz'), findsNothing);

      await closeSearch(tester);

      expect(find.byType(TextField), findsNothing);
      expect(find.text('Flutter Talk'), findsOneWidget);
      expect(find.text('Morning Jazz'), findsOneWidget);
    });
  });

  group('searching upcoming rooms', () {
    final upcoming = [
      fakeUpcomingRoom(id: 'u1', name: 'Book Club', description: 'reading'),
      fakeUpcomingRoom(id: 'u2', name: 'Night Owls', description: 'late chat'),
    ];

    // The query is held per tab, so typing on Upcoming must not filter Live.
    testAppWidget('the query applies to whichever tab is showing', (
      tester,
    ) async {
      isLiveSelected = false;
      await pumpHome(
        tester,
        live: [fakeAppwriteRoom(id: 'r1', name: 'Flutter Talk')],
        upcoming: upcoming,
      );
      await openSearch(tester);

      await type(tester, 'book');

      expect(find.text('Book Club'), findsOneWidget);
      expect(find.text('Night Owls'), findsNothing);
    });

    testAppWidget('an upcoming query that matches nothing says so', (
      tester,
    ) async {
      isLiveSelected = false;
      await pumpHome(tester, upcoming: upcoming);
      await openSearch(tester);

      await type(tester, 'zzzz');

      expect(find.text('No Search Results'), findsOneWidget);
    });

    testAppWidget('switching tabs leaves the other tab unfiltered', (
      tester,
    ) async {
      await pumpHome(
        tester,
        live: [fakeAppwriteRoom(id: 'r1', name: 'Flutter Talk')],
        upcoming: upcoming,
      );
      await openSearch(tester);
      await type(tester, 'flutter');
      await closeSearch(tester);

      await tester.tap(find.text('UPCOMING'));
      await tester.pumpAndSettle();

      expect(find.text('Book Club'), findsOneWidget);
      expect(find.text('Night Owls'), findsOneWidget);
    });
  });

  group('pull to refresh', () {
    testAppWidget('reloads both lists', (tester) async {
      await pumpHome(
        tester,
        live: [fakeAppwriteRoom(id: 'r1', name: 'Flutter Talk')],
      );
      expect(liveRooms.refreshCount, 0);

      await tester.fling(find.text('Flutter Talk'), const Offset(0, 400), 1000);
      await tester.pumpAndSettle();

      expect(liveRooms.refreshCount, 1);
      expect(upcomingRooms.refreshCount, 1);
    });
  });
}
