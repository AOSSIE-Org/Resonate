import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:resonate/core/providers/get_storage_provider.dart';
import 'package:resonate/features/auth/data/repositories/auth_repository.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/rooms/data/live_rooms.dart';
import 'package:resonate/features/rooms/data/upcoming_rooms.dart';
import 'package:resonate/features/rooms/view/pages/create_room_page.dart';
import 'package:resonate/features/settings/model/app_feature.dart';
import 'package:resonate/features/shell/view/pages/home_screen.dart';
import 'package:resonate/features/shell/view/pages/tabview_screen.dart';
import 'package:resonate/features/shell/viewmodel/tabview_notifier.dart';
import 'package:resonate/features/stories/data/explore_stories.dart';
import 'package:resonate/features/stories/view/pages/explore_page.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/utils/ui_sizes.dart';

import '../../rooms/rooms_test_helpers.dart';
import '../../stories/view/stories_test_helpers.dart';

class StubTabView extends TabView {
  StubTabView(this.initial);

  final int initial;
  final List<int> setIndexCalls = [];

  @override
  int build() => initial;

  @override
  void setIndex(int index) {
    setIndexCalls.add(index);
    state = index;
  }
}

void main() {
  late StubTabView tabView;
  late FakeGetStorage storage;
  late GoRouter router;

  setUp(() {
    storage = FakeGetStorage();
    isLiveSelected = true;
    router = GoRouter(
      initialLocation: RoutePaths.tabview,
      routes: [
        GoRoute(
          path: RoutePaths.tabview,
          builder: (_, _) => const TabViewScreen(),
        ),
        GoRoute(
          path: RoutePaths.createStoryScreen,
          builder: (_, _) => const Scaffold(body: Text('create story')),
        ),
        GoRoute(
          path: RoutePaths.emailVerification,
          builder: (_, _) => const Scaffold(body: Text('verify email')),
        ),
      ],
    );
  });

  tearDown(() {
    router.dispose();
    isLiveSelected = true;
  });

  Future<void> pumpTabView(
    WidgetTester tester, {
    int index = 0,
    bool emailVerified = true,
    bool pairChatEnabled = true,
  }) async {
    tester.view.physicalSize = const Size(1200, 2340);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await storage.write(AppFeature.pairChat.storageKey, pairChatEnabled);
    tabView = StubTabView(index);

    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          FakeAuthRepository(
            AuthState.authenticated(
              fakeAuthUser(uid: 'me', isEmailVerified: emailVerified),
            ),
          ),
        ),
        getStorageBoxProvider.overrideWithValue(storage),
        tabViewProvider.overrideWith(() => tabView),
        liveRoomsProvider.overrideWith(() => FakeLiveRooms()),
        upcomingRoomsProvider.overrideWith(FakeUpcomingRooms.new),
        exploreStoriesProvider.overrideWith(
          () => FakeExploreStories(Future.value(const [])),
        ),
        ...activityStatusOverrides(),
        ...achievementOverrides(),
      ],
    );
    addTearDown(container.dispose);
    await container.read(authSessionProvider.future);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en')],
          builder: (context, child) {
            UiSizes.init(context);
            return child!;
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> openSpeedDial(WidgetTester tester) async {
    await tester.tap(find.byType(SpeedDial));
    await tester.pumpAndSettle();
  }

  group('which tab is showing', () {
    testWidgets('the home tab shows the room lists', (tester) async {
      await mockNetworkImagesFor(() => pumpTabView(tester, index: 0));

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(ExplorePage), findsNothing);
      expect(find.text('Resonate'), findsOneWidget);
    });

    testWidgets('the search tab shows explore', (tester) async {
      await mockNetworkImagesFor(() => pumpTabView(tester, index: 1));

      expect(find.byType(ExplorePage), findsOneWidget);
      expect(find.byType(HomeScreen), findsNothing);
    });

    testWidgets('the create tab shows the room form', (tester) async {
      await mockNetworkImagesFor(() => pumpTabView(tester, index: 2));

      expect(find.byType(CreateRoomPage), findsOneWidget);
      expect(find.byType(HomeScreen), findsNothing);
    });
  });

  group('the bottom bar', () {
    testWidgets('switches tab when tapped', (tester) async {
      await mockNetworkImagesFor(() async {
        await pumpTabView(tester, index: 0);

        await tester.tap(find.byIcon(Icons.search).last);
        await tester.pumpAndSettle();
      });

      expect(tabView.setIndexCalls, contains(1));
      expect(find.byType(ExplorePage), findsOneWidget);
    });
  });

  group('the action button', () {
    // Home gets a speed dial; the other tabs get a single commit button.
    testWidgets('is a speed dial on the home tab', (tester) async {
      await mockNetworkImagesFor(() => pumpTabView(tester, index: 0));

      expect(find.byType(SpeedDial), findsOneWidget);
      expect(find.byIcon(Icons.done), findsNothing);
      expect(find.byIcon(Icons.audiotrack_rounded), findsNothing);
    });

    testWidgets('is a done button on the create tab', (tester) async {
      await mockNetworkImagesFor(() => pumpTabView(tester, index: 2));

      expect(find.byType(SpeedDial), findsNothing);
      expect(find.byIcon(Icons.done), findsOneWidget);
    });

    testWidgets('is a story button on the search tab', (tester) async {
      await mockNetworkImagesFor(() => pumpTabView(tester, index: 1));

      expect(find.byIcon(Icons.audiotrack_rounded), findsOneWidget);
    });

    testWidgets('on the search tab it opens the story composer', (
      tester,
    ) async {
      await mockNetworkImagesFor(() async {
        await pumpTabView(tester, index: 1);

        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();
      });

      expect(find.text('create story'), findsOneWidget);
    });
  });

  group('starting an audio room', () {
    testWidgets('a verified user goes straight to the form', (tester) async {
      await mockNetworkImagesFor(() async {
        await pumpTabView(tester, index: 0, emailVerified: true);
        await openSpeedDial(tester);

        await tester.tap(find.text('Audio Room'));
        await tester.pumpAndSettle();
      });

      expect(tabView.setIndexCalls, contains(2));
    });

    // Hosting needs a verified address, so the unverified user is asked first.
    testWidgets('an unverified user is asked to verify', (tester) async {
      await mockNetworkImagesFor(() async {
        await pumpTabView(tester, index: 0, emailVerified: false);
        await openSpeedDial(tester);

        await tester.tap(find.text('Audio Room'));
        await tester.pumpAndSettle();
      });

      expect(find.text('Email Verification Required'), findsOneWidget);
      expect(tabView.setIndexCalls, isNot(contains(2)));
    });

    testWidgets('accepting the prompt opens verification', (tester) async {
      await mockNetworkImagesFor(() async {
        await pumpTabView(tester, index: 0, emailVerified: false);
        await openSpeedDial(tester);
        await tester.tap(find.text('Audio Room'));
        await tester.pumpAndSettle();

        await tester.tap(find.widgetWithText(ElevatedButton, 'Verify'));
        await tester.pumpAndSettle();
      });

      expect(find.text('verify email'), findsOneWidget);
    });
  });

  group('the pair chat entry point', () {
    testWidgets('is offered while the feature is on', (tester) async {
      await mockNetworkImagesFor(() async {
        await pumpTabView(tester, index: 0, pairChatEnabled: true);
        await openSpeedDial(tester);
      });

      expect(find.text('Pair Chat'), findsOneWidget);
    });

    // Settings -> Features can hide it; the dial must drop the entry.
    testWidgets('is gone while the feature is off', (tester) async {
      await mockNetworkImagesFor(() async {
        await pumpTabView(tester, index: 0, pairChatEnabled: false);
        await openSpeedDial(tester);
      });

      expect(find.text('Audio Room'), findsOneWidget);
      expect(find.text('Pair Chat'), findsNothing);
    });
  });

  group('backing out', () {
    PopScope popScope(WidgetTester tester) =>
        tester.widgetList(find.byWidgetPredicate((w) => w is PopScope)).first
            as PopScope;

    testWidgets('the home tab lets the pop through', (tester) async {
      await mockNetworkImagesFor(() => pumpTabView(tester, index: 0));

      expect(popScope(tester).canPop, isTrue);
    });

    testWidgets('the create tab refuses the pop', (tester) async {
      await mockNetworkImagesFor(() => pumpTabView(tester, index: 2));

      expect(popScope(tester).canPop, isFalse);
    });

    testWidgets('the search tab refuses it too', (tester) async {
      await mockNetworkImagesFor(() => pumpTabView(tester, index: 1));

      expect(popScope(tester).canPop, isFalse);
    });

    testWidgets('backing out of create returns to the room lists', (
      tester,
    ) async {
      await mockNetworkImagesFor(() async {
        await pumpTabView(tester, index: 2);
        expect(find.byType(CreateRoomPage), findsOneWidget);

        popScope(tester).onPopInvokedWithResult!(false, null);
        await tester.pumpAndSettle();
      });

      expect(tabView.setIndexCalls, contains(0));
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(CreateRoomPage), findsNothing);
    });

    testWidgets('backing out of search returns there as well', (tester) async {
      await mockNetworkImagesFor(() async {
        await pumpTabView(tester, index: 1);

        popScope(tester).onPopInvokedWithResult!(false, null);
        await tester.pumpAndSettle();
      });

      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });
}
