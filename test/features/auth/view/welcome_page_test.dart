import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:resonate/features/auth/data/repositories/auth_repository.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/auth/view/pages/welcome_page.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/utils/ui_sizes.dart';

import '../../../helpers/test_root_container.dart';

class CountingAuthRepository extends FakeAuthRepository {
  CountingAuthRepository() : super(const AuthState.unauthenticated());

  int googleCalls = 0;
  int githubCalls = 0;

  @override
  Future<void> loginWithGoogle() async {
    googleCalls++;
    await super.loginWithGoogle();
  }

  @override
  Future<void> loginWithGithub() async {
    githubCalls++;
    await super.loginWithGithub();
  }
}

void main() {
  late CountingAuthRepository auth;
  late GoRouter router;

  setUp(() {
    auth = CountingAuthRepository();
    router = GoRouter(
      initialLocation: RoutePaths.welcome,
      routes: [
        GoRoute(
          path: RoutePaths.welcome,
          builder: (_, _) => const WelcomePage(),
        ),
        GoRoute(
          path: RoutePaths.login,
          builder: (_, _) => const Scaffold(body: Text('login page')),
        ),
        GoRoute(
          path: RoutePaths.signup,
          builder: (_, _) => const Scaffold(body: Text('signup page')),
        ),
      ],
    );
  });

  tearDown(() => router.dispose());

  Future<void> pumpWelcome(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 2600);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [authRepositoryProvider.overrideWithValue(auth)],
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

  group('the page', () {
    testWidgets('introduces the app', (tester) async {
      await pumpWelcome(tester);

      expect(find.text('Resonate'), findsOneWidget);
      expect(find.textContaining('Enter a world of limitless'), findsOneWidget);
    });

    testWidgets('offers email and both OAuth providers', (tester) async {
      await pumpWelcome(tester);

      expect(
        find.widgetWithText(ElevatedButton, 'Sign in with Email'),
        findsOneWidget,
      );
      expect(find.byIcon(FontAwesomeIcons.google.data), findsOneWidget);
      expect(find.byIcon(FontAwesomeIcons.github.data), findsOneWidget);
    });
  });

  // _OptionRow used to overflow its Row in a portrait aspect; its label is
  // wrapped in an Expanded now, so opening the sheet must stay clean.
  Future<void> openEmailSheet(WidgetTester tester) async {
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign in with Email'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  }

  group('signing in with email', () {
    testWidgets('opens the account sheet', (tester) async {
      await pumpWelcome(tester);

      await openEmailSheet(tester);

      expect(find.text('I already have an account'), findsOneWidget);
      expect(find.text('Create new account'), findsOneWidget);
    });

    testWidgets('the sheet can route on to login', (tester) async {
      await pumpWelcome(tester);
      await openEmailSheet(tester);

      await tester.tap(find.text('I already have an account'));
      await tester.pumpAndSettle();

      expect(find.text('login page'), findsOneWidget);
    });
  });

  group('the OAuth buttons', () {
    testWidgets('Google asks for a Google session', (tester) async {
      await pumpWelcome(tester);

      await tester.tap(find.byIcon(FontAwesomeIcons.google.data));
      await tester.pumpAndSettle();

      expect(auth.googleCalls, 1);
      expect(auth.githubCalls, 0);
    });

    testWidgets('GitHub asks for a GitHub session', (tester) async {
      await pumpWelcome(tester);

      await tester.tap(find.byIcon(FontAwesomeIcons.github.data));
      await tester.pumpAndSettle();

      expect(auth.githubCalls, 1);
      expect(auth.googleCalls, 0);
    });

    testWidgets('are labelled for assistive tech', (tester) async {
      await pumpWelcome(tester);

      expect(find.byTooltip('Continue with Google'), findsOneWidget);
      expect(find.byTooltip('Continue with GitHub'), findsOneWidget);
    });
  });
}
