import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:resonate/core/providers/get_storage_provider.dart';
import 'package:resonate/features/auth/view/pages/landing_page.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/utils/ui_sizes.dart';

import '../../../helpers/test_root_container.dart';

void main() {
  late FakeGetStorage storage;
  late GoRouter router;

  setUp(() {
    storage = FakeGetStorage();
    router = GoRouter(
      initialLocation: RoutePaths.landing,
      routes: [
        GoRoute(
          path: RoutePaths.landing,
          builder: (_, _) => const LandingPage(),
        ),
        GoRoute(
          path: RoutePaths.welcome,
          builder: (_, _) => const Scaffold(body: Text('welcome page')),
        ),
      ],
    );
  });

  tearDown(() => router.dispose());

  String location() => router.routeInformationProvider.value.uri.toString();

  Future<void> pumpLanding(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [getStorageBoxProvider.overrideWithValue(storage)],
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

  group('the slides', () {
    testWidgets('open on the welcome slide', (tester) async {
      await pumpLanding(tester);

      expect(find.text('Welcome to Resonate'), findsOneWidget);
      expect(find.textContaining('Join the conversation!'), findsOneWidget);
    });

    testWidgets('offer a way to skip ahead', (tester) async {
      await pumpLanding(tester);

      expect(find.text('Skip'), findsOneWidget);
    });

    testWidgets('carry all three pitches', (tester) async {
      await pumpLanding(tester);

      // Only the current slide is laid out, so each is checked after a swipe.
      expect(find.text('Welcome to Resonate'), findsOneWidget);

      await tester.drag(find.byType(PageView).first, const Offset(-400, 0));
      await tester.pumpAndSettle();
      expect(find.text('Explore Diverse Conversations'), findsOneWidget);

      await tester.drag(find.byType(PageView).first, const Offset(-400, 0));
      await tester.pumpAndSettle();
      expect(find.text('Your Voice Matters'), findsOneWidget);
    });

    // The finish button only appears once there is nothing left to show.
    testWidgets('only offer Get Started on the last slide', (tester) async {
      await pumpLanding(tester);
      expect(find.text('Get Started'), findsNothing);

      await tester.drag(find.byType(PageView).first, const Offset(-400, 0));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(PageView).first, const Offset(-400, 0));
      await tester.pumpAndSettle();

      expect(find.text('Get Started'), findsOneWidget);
    });
  });

  group('finishing', () {
    Future<void> reachTheEnd(WidgetTester tester) async {
      await pumpLanding(tester);
      for (var i = 0; i < 2; i++) {
        await tester.drag(find.byType(PageView).first, const Offset(-400, 0));
        await tester.pumpAndSettle();
      }
    }

    testWidgets('moves on to the welcome page', (tester) async {
      await reachTheEnd(tester);

      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();

      expect(location(), RoutePaths.welcome);
      expect(find.text('welcome page'), findsOneWidget);
    });

    // splash_page reads this flag to decide whether to show the slides again.
    testWidgets('records that the slides have been seen', (tester) async {
      await reachTheEnd(tester);

      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();

      expect(storage.read<bool>('landingScreenShown'), isTrue);
    });

    testWidgets('skipping also moves on', (tester) async {
      await pumpLanding(tester);

      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();

      expect(find.text('Your Voice Matters'), findsOneWidget);
    });
  });
}
