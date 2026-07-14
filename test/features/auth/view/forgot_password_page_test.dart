import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/auth/view/pages/forgot_password_page.dart';

import '../auth_test_helpers.dart';

class _RecordingRepo extends FakeAuthRepository {
  _RecordingRepo() : super(const AuthState.unauthenticated());

  int recoveryCount = 0;
  String? lastEmail;

  @override
  Future<void> sendPasswordRecovery({
    required String email,
    required String redirectUrl,
  }) async {
    recoveryCount++;
    lastEmail = email;
  }
}

void main() {
  testWidgets('renders the email field and a submit button', (tester) async {
    await pumpAuthPage(tester, const ForgotPasswordPage());

    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('an invalid email blocks the recovery request', (tester) async {
    final repo = _RecordingRepo();
    await pumpAuthPage(tester, const ForgotPasswordPage(), authRepository: repo);

    await tester.enterText(find.byType(TextFormField), 'not-an-email');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(repo.recoveryCount, 0);
  });

  testWidgets('a valid email sends a recovery request', (tester) async {
    final repo = _RecordingRepo();
    await pumpAuthPage(tester, const ForgotPasswordPage(), authRepository: repo);

    await tester.enterText(find.byType(TextFormField), 'user@test.com');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(repo.recoveryCount, 1);
    expect(repo.lastEmail, 'user@test.com');
  });
}
