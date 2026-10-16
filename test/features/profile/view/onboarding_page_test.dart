import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:resonate/features/auth/data/repositories/auth_repository.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/interests/model/interest.dart';
import 'package:resonate/features/profile/data/repositories/profile_repository.dart';
import 'package:resonate/features/profile/view/pages/onboarding_page.dart';
import 'package:resonate/features/stories/data/repositories/stories_repository.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/utils/ui_sizes.dart';

import '../../../helpers/test_root_container.dart';
import '../profile_test_helpers.dart';

const _pastDebounce = Duration(milliseconds: 900);

void main() {
  late FakeProfileRepository repo;
  late GoRouter router;

  setUp(() {
    repo = FakeProfileRepository();
    // The success path calls context.go, so the page needs a real router.
    router = GoRouter(
      initialLocation: RoutePaths.onboarding,
      routes: [
        GoRoute(
          path: RoutePaths.onboarding,
          builder: (_, _) => const OnboardingPage(),
        ),
        GoRoute(
          path: RoutePaths.tabview,
          builder: (_, _) => const SizedBox.shrink(),
        ),
      ],
    );
  });

  tearDown(() => router.dispose());

  String location() => router.routeInformationProvider.value.uri.toString();

  Future<void> pumpOnboarding(WidgetTester tester) async {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          FakeAuthRepository(
            AuthState.authenticated(fakeAuthUser(isProfileComplete: false)),
          ),
        ),
        profileRepositoryProvider.overrideWithValue(repo),
        storiesRepositoryProvider.overrideWithValue(FakeStoriesRepository()),
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

  Finder nameField() => find.byType(TextFormField).at(0);
  Finder usernameField() => find.byType(TextFormField).at(1);
  Finder dobField() => find.byType(TextFormField).at(2);
  Finder submitButton() => find.widgetWithText(ElevatedButton, 'Submit');

  // The field is read-only and opens a date picker; today's date is fine.
  Future<void> pickDate(WidgetTester tester) async {
    await tester.ensureVisible(dobField());
    await tester.pumpAndSettle();
    await tester.tap(dobField());
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
  }

  Future<void> submit(WidgetTester tester) async {
    await tester.ensureVisible(submitButton());
    await tester.pumpAndSettle();
    await tester.tap(submitButton());
    await tester.pumpAndSettle();
  }

  Future<void> fillValidForm(WidgetTester tester) async {
    await tester.enterText(nameField(), 'Ada Lovelace');
    await tester.enterText(usernameField(), 'ada_lovelace');
    await tester.pump(_pastDebounce);
    await tester.pumpAndSettle();
    await pickDate(tester);
  }

  group('the form', () {
    testWidgets('asks for a name, username and date of birth', (tester) async {
      await mockNetworkImagesFor(() => pumpOnboarding(tester));

      expect(find.text('Complete your Profile'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(3));
      expect(submitButton(), findsOneWidget);
    });

    testWidgets('an empty form reports every missing field', (tester) async {
      await mockNetworkImagesFor(() async {
        await pumpOnboarding(tester);
        await submit(tester);
      });

      expect(find.text('Enter Valid Name'), findsOneWidget);
      expect(
        find.text('Username should contain more than 7 characters.'),
        findsOneWidget,
      );
      expect(find.text('Enter Valid DOB'), findsOneWidget);
      expect(repo.createUserRowUid, isNull);
    });

    testWidgets('an illegally formatted username is rejected', (tester) async {
      await mockNetworkImagesFor(() async {
        await pumpOnboarding(tester);
        await tester.enterText(usernameField(), 'not a username!');
        await submit(tester);
      });

      expect(
        find.textContaining('Only letters, numbers, dots'),
        findsOneWidget,
      );
      expect(repo.createUserRowUid, isNull);
    });

    testWidgets('the date picker fills the date field', (tester) async {
      await mockNetworkImagesFor(() async {
        await pumpOnboarding(tester);
        await pickDate(tester);
      });

      final dob = tester.widget<TextFormField>(dobField());
      expect(dob.controller!.text, isNotEmpty);
      expect(find.text('Enter Valid DOB'), findsNothing);
    });
  });

  group('the username check', () {
    testWidgets('shows it is checking, then confirms availability', (
      tester,
    ) async {
      repo.usernameAvailableReturn = true;
      await mockNetworkImagesFor(() async {
        await pumpOnboarding(tester);

        await tester.enterText(usernameField(), 'ada_lovelace');
        await tester.pump();
        expect(find.text('Checking...'), findsOneWidget);

        await tester.pump(_pastDebounce);
        await tester.pumpAndSettle();
      });

      expect(repo.isUsernameAvailableArg, 'ada_lovelace');
      expect(find.byIcon(Icons.verified_outlined), findsOneWidget);
    });

    testWidgets('a taken username gets no confirmation tick', (tester) async {
      repo.usernameAvailableReturn = false;
      await mockNetworkImagesFor(() async {
        await pumpOnboarding(tester);
        await tester.enterText(usernameField(), 'taken_username');
        await tester.pump(_pastDebounce);
        await tester.pumpAndSettle();
      });

      expect(find.byIcon(Icons.verified_outlined), findsNothing);
    });

    // A username that cannot be valid should never cost a round trip.
    testWidgets('a malformed username is never looked up', (tester) async {
      await mockNetworkImagesFor(() async {
        await pumpOnboarding(tester);
        await tester.enterText(usernameField(), 'short');
        await tester.pump(_pastDebounce);
        await tester.pumpAndSettle();
      });

      expect(repo.isUsernameAvailableArg, isNull);
    });
  });

  group('interests', () {
    testWidgets('are optional and start unselected', (tester) async {
      await mockNetworkImagesFor(() => pumpOnboarding(tester));

      final chips = tester.widgetList<FilterChip>(find.byType(FilterChip));
      expect(chips, isNotEmpty);
      expect(chips.every((c) => !c.selected), isTrue);
    });

    testWidgets('tapping one selects it, tapping again clears it', (
      tester,
    ) async {
      await mockNetworkImagesFor(() async {
        await pumpOnboarding(tester);
        final chip = find.byType(FilterChip).first;

        await tester.ensureVisible(chip);
        await tester.pumpAndSettle();
        await tester.tap(chip);
        await tester.pumpAndSettle();
        expect(tester.widget<FilterChip>(chip).selected, isTrue);

        await tester.tap(chip);
        await tester.pumpAndSettle();
        expect(tester.widget<FilterChip>(chip).selected, isFalse);
      });
    });

    // The cap is enforced by the notifier; the sixth tap must not stick.
    testWidgets('stops accepting new ones at the cap', (tester) async {
      await mockNetworkImagesFor(() async {
        await pumpOnboarding(tester);

        for (var i = 0; i <= Interest.maxSelectable; i++) {
          final chip = find.byType(FilterChip).at(i);
          await tester.ensureVisible(chip);
          await tester.pumpAndSettle();
          await tester.tap(chip);
          await tester.pumpAndSettle();
        }
      });

      final selected = tester
          .widgetList<FilterChip>(find.byType(FilterChip))
          .where((c) => c.selected);
      expect(selected, hasLength(Interest.maxSelectable));
    });
  });

  group('submitting', () {
    testWidgets('creates the profile and moves on to the app', (tester) async {
      await mockNetworkImagesFor(() async {
        await pumpOnboarding(tester);
        await fillValidForm(tester);
        await submit(tester);
      });

      expect(repo.createUsernameRowArgs?.username, 'ada_lovelace');
      expect(repo.updateAccountNameArg, 'Ada Lovelace');
      expect(repo.createUserRowData?['name'], 'Ada Lovelace');
      expect(repo.createUserRowData?['username'], 'ada_lovelace');
      expect(repo.createUserRowData?['dob'], isNotEmpty);
      expect(repo.markProfileCompleteCount, 1);
      expect(location(), RoutePaths.tabview);
    });

    testWidgets('carries the chosen interests through', (tester) async {
      await mockNetworkImagesFor(() async {
        await pumpOnboarding(tester);
        final chip = find.byType(FilterChip).first;
        await tester.ensureVisible(chip);
        await tester.pumpAndSettle();
        await tester.tap(chip);
        await tester.pumpAndSettle();

        await fillValidForm(tester);
        await submit(tester);
      });

      expect(repo.createUserRowData?['interests'], hasLength(1));
    });

    // The name is checked again at submit time, because it may have been
    // taken between the debounce and the tap.
    testWidgets('a username taken since the check stops the profile', (
      tester,
    ) async {
      await mockNetworkImagesFor(() async {
        await pumpOnboarding(tester);
        await fillValidForm(tester);
        repo.usernameAvailableReturn = false;
        await submit(tester);
      });

      expect(repo.createUserRowUid, isNull);
      expect(repo.markProfileCompleteCount, 0);
      expect(location(), RoutePaths.onboarding, reason: 'stays on the form');
    });

    testWidgets('a backend failure leaves the user on the form', (
      tester,
    ) async {
      repo.createUsernameRowError = Exception('network down');
      await mockNetworkImagesFor(() async {
        await pumpOnboarding(tester);
        await fillValidForm(tester);
        await submit(tester);
      });

      expect(repo.markProfileCompleteCount, 0);
      expect(location(), RoutePaths.onboarding);
    });
  });
}
