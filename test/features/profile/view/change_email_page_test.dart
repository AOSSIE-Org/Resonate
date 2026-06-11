import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/profile/view/pages/change_email_page.dart';

import 'profile_test_helpers.dart';

void main() {
  testWidgets('renders the email + password fields and a submit button',
      (tester) async {
    await pumpProfilePage(
      tester,
      const ChangeEmailPage(),
      authState: AuthState.authenticated(fakeAuthUser()),
    );

    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('password visibility toggle flips the eye icon', (tester) async {
    await pumpProfilePage(
      tester,
      const ChangeEmailPage(),
      authState: AuthState.authenticated(fakeAuthUser()),
    );

    expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    await tester.tap(find.byIcon(Icons.visibility_off_outlined));
    await tester.pump();
    expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
  });

  testWidgets('an invalid email blocks submission', (tester) async {
    final repo = FakeProfileRepository();
    await pumpProfilePage(
      tester,
      const ChangeEmailPage(),
      authState: AuthState.authenticated(fakeAuthUser()),
      profileRepo: repo,
    );

    await tester.enterText(find.byType(TextFormField).at(0), 'not-an-email');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(repo.changeEmailInAuthArgs, isNull);
  });

  testWidgets('valid input runs the change-email flow', (tester) async {
    final repo = FakeProfileRepository();
    await pumpProfilePage(
      tester,
      const ChangeEmailPage(),
      authState: AuthState.authenticated(fakeAuthUser(userName: 'TestUser')),
      profileRepo: repo,
    );

    await tester.enterText(find.byType(TextFormField).at(0), 'new@test.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(repo.changeEmailInAuthArgs?.email, 'new@test.com');
  });
}
