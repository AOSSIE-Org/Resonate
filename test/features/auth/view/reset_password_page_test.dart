import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/auth/view/pages/reset_password_page.dart';

import '../auth_test_helpers.dart';

class _RecordingResetRepo extends FakeAuthRepository {
  _RecordingResetRepo() : super(const AuthState.unauthenticated());

  int count = 0;

  @override
  Future<void> completePasswordRecovery({
    required String userId,
    required String secret,
    required String newPassword,
  }) async {
    count++;
    throw Exception('stop-navigation');
  }
}

void main() {
  testWidgets('renders the new-password field and set-password button',
      (tester) async {
    await pumpAuthPage(
      tester,
      const ResetPasswordPage(userId: 'u1', secret: 's1'),
    );

    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.byType(MaterialButton), findsOneWidget);
  });

  testWidgets('tapping set-password invokes the reset flow', (tester) async {
    final repo = _RecordingResetRepo();
    await pumpAuthPage(
      tester,
      const ResetPasswordPage(userId: 'u1', secret: 's1'),
      authRepository: repo,
    );

    await tester.enterText(find.byType(TextFormField), 'NewPass1!');
    await tester.tap(find.byType(MaterialButton));
    await tester.pumpAndSettle();

    expect(repo.count, 1);
  });
}
