import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:resonate/features/auth/data/repositories/auth_repository.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/auth/view/pages/signup_page.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/utils/ui_sizes.dart';

import '../auth_test_helpers.dart';

/// Field validation and the signed-up hand-off. `signup_page_test.dart`
/// covers the field rendering and the visibility toggles.
void main() {
  late FakeAuthRepository auth;
  late GoRouter router;

  setUp(() {
    auth = FakeAuthRepository(const AuthState.unauthenticated());
    router = GoRouter(
      initialLocation: RoutePaths.signup,
      routes: [
        GoRoute(path: RoutePaths.signup, builder: (_, _) => const SignupPage()),
        GoRoute(
          path: RoutePaths.onboarding,
          builder: (_, _) => const Scaffold(body: Text('onboarding page')),
        ),
      ],
    );
  });

  tearDown(() => router.dispose());

  String location() => router.routeInformationProvider.value.uri.toString();

  Future<void> pumpSignup(WidgetTester tester) async {
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

  Finder emailField() => find.byType(TextFormField).at(0);
  Finder passwordField() => find.byType(TextFormField).at(1);
  Finder confirmField() => find.byType(TextFormField).at(2);

  Future<void> submit(WidgetTester tester) async {
    await tester.ensureVisible(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
  }

  Future<void> fill(
    WidgetTester tester, {
    String email = 'user@test.com',
    String password = 'Abcdef1!',
    String? confirm,
  }) async {
    await tester.enterText(emailField(), email);
    await tester.enterText(passwordField(), password);
    await tester.enterText(confirmField(), confirm ?? password);
  }

  group('validation', () {
    testWidgets('a malformed email is rejected', (tester) async {
      await pumpSignup(tester);

      await fill(tester, email: 'not-an-email');
      await submit(tester);

      expect(find.text('Enter Valid Email Address'), findsOneWidget);
      expect(auth.signupCount, 0);
    });

    testWidgets('an empty password is rejected', (tester) async {
      await pumpSignup(tester);

      await fill(tester, password: '', confirm: '');
      await submit(tester);

      expect(find.text('Password cannot be empty'), findsOneWidget);
      expect(auth.signupCount, 0);
    });

    // The rule is length; a short password names it rather than failing
    // silently.
    testWidgets('a too-short password names the requirement', (tester) async {
      await pumpSignup(tester);

      await fill(tester, password: 'Ab1!');
      await submit(tester);

      // Both the password and confirm fields run the same rule.
      expect(
        find.text('Password must be at least 8 characters long'),
        findsWidgets,
      );
      expect(auth.signupCount, 0);
    });

    testWidgets('an empty email is rejected', (tester) async {
      await pumpSignup(tester);

      await fill(tester, email: '');
      await submit(tester);

      expect(auth.signupCount, 0);
      expect(location(), RoutePaths.signup);
    });
  });

  group('signing up', () {
    testWidgets('a valid form reaches the repository', (tester) async {
      await pumpSignup(tester);

      await fill(tester);
      await submit(tester);

      expect(auth.signupCount, 1);
    });

    // A new account has no profile yet, so the next stop is onboarding.
    testWidgets('a successful signup moves on to onboarding', (tester) async {
      await pumpSignup(tester);

      await fill(tester);
      await submit(tester);

      expect(location(), RoutePaths.onboarding);
      expect(find.text('onboarding page'), findsOneWidget);
    });
  });
}
