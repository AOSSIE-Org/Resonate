import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:resonate/core/providers/get_storage_provider.dart';
import 'package:resonate/features/auth/data/repositories/auth_repository.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/auth/view/pages/splash_page.dart';
import 'package:resonate/features/shell/data/app_bootstrap.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/utils/ui_sizes.dart';

import '../../../helpers/test_root_container.dart';

class FakeAppBootstrap extends AppBootstrap {
  @override
  Future<void> build() async {}
}

void main() {
  late FakeGetStorage storage;
  late GoRouter router;

  setUp(() {
    storage = FakeGetStorage();
    router = GoRouter(
      initialLocation: RoutePaths.splash,
      routes: [
        GoRoute(path: RoutePaths.splash, builder: (_, _) => const SplashPage()),
        for (final path in [
          RoutePaths.tabview,
          RoutePaths.onboarding,
          RoutePaths.userBlocked,
          RoutePaths.welcome,
          RoutePaths.landing,
        ])
          GoRoute(
            path: path,
            builder: (_, _) => Scaffold(body: Text('at $path')),
          ),
      ],
    );
  });

  tearDown(() => router.dispose());

  String location() => router.routeInformationProvider.value.uri.toString();

  Future<void> pumpSplash(
    WidgetTester tester, {
    required AuthState authState,
    bool landingShown = false,
  }) async {
    await storage.write('landingScreenShown', landingShown);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            FakeAuthRepository(authState),
          ),
          getStorageBoxProvider.overrideWithValue(storage),
          appBootstrapProvider.overrideWith(FakeAppBootstrap.new),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          builder: (context, child) {
            UiSizes.init(context);
            return child!;
          },
        ),
      ),
    );
    await tester.pump();
  }

  // The page waits 3s before deciding where to go.
  Future<void> settleSplash(WidgetTester tester) async {
    await tester.pump(const Duration(seconds: 4));
    await tester.pump();
    await tester.pump();
    await tester.pumpAndSettle();
  }

  testWidgets('shows the logos while it waits', (tester) async {
    await pumpSplash(tester, authState: const AuthState.unauthenticated());

    expect(find.byType(Image), findsNWidgets(2));
    expect(
      find.descendant(
        of: find.byType(SplashPage),
        matching: find.byType(FadeTransition),
      ),
      findsOneWidget,
    );
    expect(location(), RoutePaths.splash, reason: 'has not decided yet');

    await settleSplash(tester);
  });

  group('where it sends you', () {
    testWidgets('a signed-in user goes to the app', (tester) async {
      await pumpSplash(
        tester,
        authState: AuthState.authenticated(fakeAuthUser()),
      );

      await settleSplash(tester);

      expect(location(), RoutePaths.tabview);
    });

    testWidgets('an unfinished profile goes to onboarding', (tester) async {
      await pumpSplash(
        tester,
        authState: AuthState.needsOnboarding(
          fakeAuthUser(isProfileComplete: false),
        ),
      );

      await settleSplash(tester);

      expect(location(), RoutePaths.onboarding);
    });

    testWidgets('a blocked user goes to the blocked screen', (tester) async {
      await pumpSplash(tester, authState: AuthState.blocked(fakeAuthUser()));

      await settleSplash(tester);

      expect(location(), RoutePaths.userBlocked);
    });

    // First run: the slides come before the sign-in choice.
    testWidgets('a first-time visitor sees the landing slides', (tester) async {
      await pumpSplash(
        tester,
        authState: const AuthState.unauthenticated(),
        landingShown: false,
      );

      await settleSplash(tester);

      expect(location(), RoutePaths.landing);
    });

    testWidgets('a returning visitor skips straight to welcome', (
      tester,
    ) async {
      await pumpSplash(
        tester,
        authState: const AuthState.unauthenticated(),
        landingShown: true,
      );

      await settleSplash(tester);

      expect(location(), RoutePaths.welcome);
    });
  });
}
