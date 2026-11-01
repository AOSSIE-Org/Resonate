import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:resonate/features/auth/data/repositories/auth_repository.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/auth/view/pages/email_verification_page.dart';
import 'package:resonate/features/auth/viewmodel/email_verify_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/utils/ui_sizes.dart';

import '../../../helpers/test_root_container.dart';


class FakeEmailVerify extends EmailVerify {
  FakeEmailVerify({
    this.sendResult = (sent: true, responseBody: '{"message":"mail sent"}'),
    this.status = 'true',
    this.verifyThrows,
  });

  ({bool sent, String responseBody}) sendResult;
  String? status;
  Object? verifyThrows;

  final List<String> sentTo = [];
  final List<String> verified = [];
  final List<String> markedVerified = [];

  @override
  EmailVerifyState build() => const EmailVerifyState();

  @override
  Future<({bool sent, String responseBody})> sendOtp({
    required String email,
  }) async {
    sentTo.add(email);
    if (sendResult.sent) state = state.copyWith(canResend: false);
    return sendResult;
  }

  @override
  Future<void> verifyOtp({
    required String email,
    required String userOtp,
  }) async {
    if (verifyThrows != null) throw verifyThrows!;
    verified.add(userOtp);
  }

  @override
  Future<String?> checkVerificationStatus() async => status;

  @override
  Future<void> markVerified({required String uid}) async {
    markedVerified.add(uid);
  }
}

void main() {
  late FakeEmailVerify verify;
  late GoRouter router;

  setUp(() {
    verify = FakeEmailVerify();
    router = GoRouter(
      initialLocation: RoutePaths.emailVerification,
      routes: [
        GoRoute(
          path: RoutePaths.emailVerification,
          builder: (_, _) => const EmailVerificationPage(),
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

  Future<void> pumpPage(
    WidgetTester tester, {
    String email = 'someone@test.com',
  }) async {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          FakeAuthRepository(
            AuthState.authenticated(
              fakeAuthUser(uid: 'u1', email: email, isEmailVerified: false),
            ),
          ),
        ),
        emailVerifyProvider.overrideWith(() => verify),
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
    await tester.pump();
  }

  // OtpTextField fires onSubmit once the last of its six boxes is filled.
  Future<void> enterCode(WidgetTester tester, String code) async {
    final boxes = find.byType(TextField);
    for (var i = 0; i < code.length; i++) {
      await tester.enterText(boxes.at(i), code[i]);
      await tester.pump();
    }
    await tester.pumpAndSettle();
  }

  group('opening the page', () {
    testWidgets('sends a code straight away', (tester) async {
      await pumpPage(tester);
      await tester.pumpAndSettle();

      expect(verify.sentTo, ['someone@test.com']);
    });

    testWidgets('shows the address the code went to', (tester) async {
      await pumpPage(tester, email: 'ada@test.com');
      await tester.pumpAndSettle();

      expect(
        find.textContaining('ada@test.com', findRichText: true),
        findsOneWidget,
      );
    });

    testWidgets('offers six boxes for the code', (tester) async {
      await pumpPage(tester);
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsNWidgets(6));
    });

    // Resending is behind a countdown until the timer runs out.
    testWidgets('hides the resend link behind a countdown', (tester) async {
      await pumpPage(tester);
      // Not pumpAndSettle: that would run the 30s countdown to completion and
      // unlock the link this asserts is still hidden.
      await tester.pump();
      await tester.pump();

      expect(find.text('Request a new code'), findsNothing);
      expect(find.text('Request a new code in'), findsOneWidget);
    });

    testWidgets('unlocks the resend link when the countdown runs out', (
      tester,
    ) async {
      await pumpPage(tester);
      await tester.pump();
      expect(find.text('Request a new code'), findsNothing);

      await tester.pump(const Duration(seconds: 31));
      await tester.pumpAndSettle();

      expect(find.text('Request a new code'), findsOneWidget);
    });

    // A send that failed must not leave the user stuck behind the timer.
    testWidgets('a failed send unlocks resending immediately', (tester) async {
      verify.sendResult = (sent: false, responseBody: 'mailer down');
      await pumpPage(tester);
      await tester.pumpAndSettle();

      expect(find.text('Request a new code'), findsOneWidget);
    });

    testWidgets('a thrown send also unlocks resending', (tester) async {
      verify = FakeEmailVerify()..sendResult = (sent: false, responseBody: '');
      await pumpPage(tester);
      await tester.pumpAndSettle();

      expect(find.text('Request a new code'), findsOneWidget);
    });
  });

  group('resending', () {
    testWidgets('asks for another code', (tester) async {
      verify.sendResult = (sent: false, responseBody: 'mailer down');
      await pumpPage(tester);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Request a new code'));
      await tester.pumpAndSettle();

      expect(verify.sentTo, hasLength(2));
    });
  });

  group('submitting the code', () {
    testWidgets('verifies it and moves on to the app', (tester) async {
      await pumpPage(tester);
      await tester.pumpAndSettle();

      await enterCode(tester, '123456');

      expect(verify.verified, ['123456']);
      expect(verify.markedVerified, ['u1']);
      expect(location(), RoutePaths.tabview);
    });

    // A wrong code must not mark the account verified.
    testWidgets('a mismatch stays on the page', (tester) async {
      verify.status = 'false';
      await pumpPage(tester);
      await tester.pumpAndSettle();

      await enterCode(tester, '000000');

      expect(verify.verified, ['000000']);
      expect(verify.markedVerified, isEmpty);
      expect(location(), RoutePaths.emailVerification);
    });

    testWidgets('a missing status is treated as a mismatch', (tester) async {
      verify.status = null;
      await pumpPage(tester);
      await tester.pumpAndSettle();

      await enterCode(tester, '000000');

      expect(verify.markedVerified, isEmpty);
      expect(location(), RoutePaths.emailVerification);
    });

    testWidgets('a failure during verification stays on the page', (
      tester,
    ) async {
      verify.verifyThrows = Exception('network down');
      await pumpPage(tester);
      await tester.pumpAndSettle();

      await enterCode(tester, '123456');

      expect(verify.markedVerified, isEmpty);
      expect(location(), RoutePaths.emailVerification);
    });
  });
}
