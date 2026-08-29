import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:resonate/features/auth/data/repositories/auth_repository.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/achievements/model/user_stats.dart';
import 'package:resonate/features/achievements/view/widgets/achievements_sheet.dart';
import 'package:resonate/features/settings/view/pages/settings_screen.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/routes/app_router.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/utils/ui_sizes.dart';

import '../settings_test_helpers.dart';

GoRouter recordingRouter(List<String> log) {
  GoRoute rec(String path) => GoRoute(
    path: path,
    builder: (context, state) {
      log.add(state.uri.path);
      return const SizedBox.shrink();
    },
  );
  return GoRouter(
    initialLocation: RoutePaths.settings,
    routes: [
      GoRoute(
        path: RoutePaths.settings,
        builder: (context, state) {
          UiSizes.init(context);
          return SettingsScreen();
        },
      ),
      rec(RoutePaths.userAccountScreen),
      rec(RoutePaths.themeScreen),
      rec(RoutePaths.aboutApp),
      rec(RoutePaths.appPreferencesScreen),
      rec(RoutePaths.featuresScreen),
      rec(RoutePaths.contributeScreen),
      rec(RoutePaths.welcome),
    ],
  );
}

Future<(GoRouter, FakeAuthRepository, List<String>)> pumpSettings(
  WidgetTester tester,
) async {
  final repo = FakeAuthRepository(
    AuthState.authenticated(fakeAuthUser(uid: 'me')),
  );
  final log = <String>[];
  final router = recordingRouter(log);

  tester.view.physicalSize = const Size(1080, 2340);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        // The activity status tile watches it, which would otherwise build
        // the real Appwrite clients.
        ...activityStatusOverrides(),
        // Same for the achievements tile, whose sheet reads the stats table.
        ...achievementOverrides(
          myStats: const UserStats(roomsHosted: 12, badges: ['welcomer']),
        ),
        authRepositoryProvider.overrideWithValue(repo),
        routerProvider.overrideWithValue(router),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
      ),
    ),
  );
  // pumpAndSettle resolves the auth future the screen watches.
  await tester.pumpAndSettle();
  return (router, repo, log);
}

Future<void> revealLogOut(WidgetTester tester) async {
  await tester.scrollUntilVisible(find.text('Log out'), 200);
  await tester.pumpAndSettle();
}

void main() {
  stubFlutterSecureStorageChannel();

  testWidgets('renders section titles and all navigation tiles', (
    tester,
  ) async {
    await pumpSettings(tester);

    // section titles
    expect(find.text('Account settings'), findsOneWidget);
    expect(find.text('App settings'), findsOneWidget);
    expect(find.text('Other'), findsOneWidget);

    // navigation tiles
    expect(find.text('Account'), findsOneWidget);
    expect(find.text('Achievements'), findsOneWidget);
    expect(find.text('Themes'), findsOneWidget);
    expect(find.text('About'), findsOneWidget);
    expect(find.text('App Preferences'), findsOneWidget);
    expect(find.text('Features'), findsOneWidget);
    expect(find.text('Contribute'), findsOneWidget);

    // log out tile
    await revealLogOut(tester);
    expect(find.text('Log out'), findsOneWidget);
    expect(find.byIcon(Icons.logout_rounded), findsOneWidget);
  });

  testWidgets('Account tile pushes userAccountScreen', (tester) async {
    final (_, _, log) = await pumpSettings(tester);
    await tester.tap(find.text('Account'));
    await tester.pumpAndSettle();
    expect(log, [RoutePaths.userAccountScreen]);
  });

  testWidgets('Themes tile pushes themeScreen', (tester) async {
    final (_, _, log) = await pumpSettings(tester);
    await tester.tap(find.text('Themes'));
    await tester.pumpAndSettle();
    expect(log, [RoutePaths.themeScreen]);
  });

  testWidgets('About tile pushes aboutApp', (tester) async {
    final (_, _, log) = await pumpSettings(tester);
    await tester.tap(find.text('About'));
    await tester.pumpAndSettle();
    expect(log, [RoutePaths.aboutApp]);
  });

  testWidgets('App Preferences tile pushes appPreferencesScreen', (
    tester,
  ) async {
    final (_, _, log) = await pumpSettings(tester);
    await tester.tap(find.text('App Preferences'));
    await tester.pumpAndSettle();
    expect(log, [RoutePaths.appPreferencesScreen]);
  });

  testWidgets('Features tile pushes featuresScreen', (tester) async {
    final (_, _, log) = await pumpSettings(tester);
    await tester.tap(find.text('Features'));
    await tester.pumpAndSettle();
    expect(log, [RoutePaths.featuresScreen]);
  });

  testWidgets('Contribute tile pushes contributeScreen', (tester) async {
    final (_, _, log) = await pumpSettings(tester);
    await tester.tap(find.text('Contribute'));
    await tester.pumpAndSettle();
    expect(log, [RoutePaths.contributeScreen]);
  });

  testWidgets('Log Out opens the confirmation dialog', (tester) async {
    await pumpSettings(tester);

    await revealLogOut(tester);
    await tester.tap(find.text('Log out'));
    await tester.pumpAndSettle();

    expect(find.text('Are you sure?'), findsOneWidget);
    expect(find.text('You are logging out of Resonate.'), findsOneWidget);
    expect(find.text('No'), findsOneWidget);
    expect(find.text('Yes'), findsOneWidget);
  });

  testWidgets('No dismisses the dialog without logging out', (tester) async {
    final (_, repo, log) = await pumpSettings(tester);

    await revealLogOut(tester);
    await tester.tap(find.text('Log out'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('No'));
    await tester.pumpAndSettle();

    expect(find.text('Are you sure?'), findsNothing);
    expect(repo.logoutCount, 0);
    expect(log, isEmpty);
  });

  testWidgets('Yes logs out and navigates to welcome', (tester) async {
    final (_, repo, log) = await pumpSettings(tester);

    await revealLogOut(tester);
    await tester.tap(find.text('Log out'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Yes'));
    await tester.pumpAndSettle();

    // dialog popped, logout invoked once, routed to welcome
    expect(find.text('Are you sure?'), findsNothing);
    expect(repo.logoutCount, 1);
    expect(log, [RoutePaths.welcome]);
  });

  testWidgets('Achievements tile opens the sheet rather than a route', (
    tester,
  ) async {
    final (_, _, log) = await pumpSettings(tester);

    await tester.tap(find.text('Achievements'));
    await tester.pumpAndSettle();

    expect(find.byType(AchievementsSheet), findsOneWidget);
    expect(find.text('Rooms hosted'), findsWidgets);
    expect(log, isEmpty);
  });
}
