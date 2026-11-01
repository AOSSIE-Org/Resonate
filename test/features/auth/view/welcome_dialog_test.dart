import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:resonate/features/auth/view/widgets/welcome_dialog.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/utils/ui_sizes.dart';


void main() {
  late GoRouter router;

  setUp(() {
    router = GoRouter(
      initialLocation: RoutePaths.welcome,
      routes: [
        GoRoute(
          path: RoutePaths.welcome,
          builder: (_, _) => Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () => showModalBottomSheet<void>(
                    context: context,
                    builder: welcomeAuthDialog,
                  ),
                  child: const Text('open'),
                ),
              ),
            ),
          ),
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

  String location() => router.routeInformationProvider.value.uri.toString();

  Future<void> openSheet(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp.router(
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
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('offers signing in and signing up', (tester) async {
    await openSheet(tester);

    expect(find.text('Sign in with Email'), findsOneWidget);
    expect(find.text('I already have an account'), findsOneWidget);
    expect(find.text('Create new account'), findsOneWidget);
  });

  testWidgets('an existing account goes to the login page', (tester) async {
    await openSheet(tester);

    await tester.tap(find.text('I already have an account'));
    await tester.pumpAndSettle();

    expect(location(), RoutePaths.login);
    expect(find.text('login page'), findsOneWidget);
  });

  testWidgets('a new account goes to the signup page', (tester) async {
    await openSheet(tester);

    await tester.tap(find.text('Create new account'));
    await tester.pumpAndSettle();

    expect(location(), RoutePaths.signup);
    expect(find.text('signup page'), findsOneWidget);
  });

  // The sheet pops before routing; if it did not, it would sit over the
  // destination page.
  testWidgets('closes itself on the way out', (tester) async {
    await openSheet(tester);

    await tester.tap(find.text('I already have an account'));
    await tester.pumpAndSettle();

    expect(find.text('Sign in with Email'), findsNothing);
  });
}
