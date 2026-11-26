import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/auth/model/auth_failure.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/auth/view/pages/login_page.dart';
import 'package:resonate/l10n/app_localizations_en.dart';
import 'package:resonate/shared/widgets/snackbar.dart';

import '../auth_test_helpers.dart';

void main() {
  testWidgets('renders the email + password fields and a login button',
      (tester) async {
    await pumpAuthPage(tester, const LoginPage());

    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('password visibility toggle flips the eye icon', (tester) async {
    await pumpAuthPage(tester, const LoginPage());

    expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    await tester.tap(find.byIcon(Icons.visibility_off_outlined));
    await tester.pump();
    expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
  });

  testWidgets('an invalid email blocks login', (tester) async {
    final repo = FakeAuthRepository(const AuthState.unauthenticated());
    await pumpAuthPage(tester, const LoginPage(), authRepository: repo);

    await tester.enterText(find.byType(TextFormField).at(0), 'not-an-email');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(repo.loginCount, 0);
  });

  testWidgets('valid credentials call login', (tester) async {
    final repo = FakeAuthRepository(const AuthState.unauthenticated());
    await pumpAuthPage(tester, const LoginPage(), authRepository: repo);

    await tester.enterText(find.byType(TextFormField).at(0), 'user@test.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(repo.loginCount, 1);
  });

  testWidgets('an unknown failure shows generic copy, not the server text',
      (tester) async {
    final repo = FakeAuthRepository(
      const AuthState.unauthenticated(),
      loginFailure: const AuthFailure.unknown('server said no'),
    );
    await pumpAuthPage(
      tester,
      const LoginPage(),
      authRepository: repo,
      rootOverlay: true,
    );

    await tester.enterText(find.byType(TextFormField).at(0), 'user@test.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(find.text(AppLocalizationsEn().somethingWentWrong), findsOneWidget);
    expect(find.text('server said no'), findsNothing);
    dismissCustomSnackbar();
    await tester.pump();
  });
}
