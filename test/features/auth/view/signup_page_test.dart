import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/auth/view/pages/signup_page.dart';
import 'package:resonate/features/auth/viewmodel/signup_form_notifier.dart';

import '../auth_test_helpers.dart';

void main() {
  testWidgets('renders email, password, confirm fields and a sign-up button',
      (tester) async {
    await pumpAuthPage(tester, const SignupPage());

    expect(find.byType(TextFormField), findsNWidgets(3));
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('both password fields have independent visibility toggles',
      (tester) async {
    await pumpAuthPage(tester, const SignupPage());

    expect(find.byIcon(Icons.visibility_off_outlined), findsNWidgets(2));

    await tester.tap(find.byIcon(Icons.visibility_off_outlined).first);
    await tester.pump();
    expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);

    await tester.tap(find.byIcon(Icons.visibility_off_outlined));
    await tester.pump();
    expect(find.byIcon(Icons.visibility_outlined), findsNWidgets(2));
  });

  testWidgets('mismatched passwords block sign-up', (tester) async {
    final repo = FakeAuthRepository(const AuthState.unauthenticated());
    await pumpAuthPage(tester, const SignupPage(), authRepository: repo);

    await tester.enterText(find.byType(TextFormField).at(0), 'user@test.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'Abcdef1!');
    await tester.enterText(find.byType(TextFormField).at(2), 'different');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(repo.signupCount, 0);
  });

  testWidgets('typing in the password field updates the signup strength state',
      (tester) async {
    await pumpAuthPage(tester, const SignupPage());
    final container =
        ProviderScope.containerOf(tester.element(find.byType(SignupPage)));

    expect(container.read(signupFormProvider).strength.score, 0);

    await tester.enterText(find.byType(TextFormField).at(1), 'Abcdef1!');
    await tester.pumpAndSettle();

    final strength = container.read(signupFormProvider).strength;
    expect(strength.score, 5);
    expect(strength.meetsFormRequirements, true);
  });
}
