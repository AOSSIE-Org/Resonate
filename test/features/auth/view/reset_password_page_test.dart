import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/auth/model/auth_failure.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/auth/view/pages/reset_password_page.dart';
import 'package:resonate/l10n/app_localizations_en.dart';
import 'package:resonate/shared/widgets/snackbar.dart';

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

  testWidgets('a short password shows the password message', (tester) async {
    final repo = _FailingResetRepo(const AuthFailure.passwordTooShort());
    await pumpAuthPage(
      tester,
      const ResetPasswordPage(userId: 'u1', secret: 's1'),
      authRepository: repo,
      rootOverlay: true,
    );

    await tester.enterText(find.byType(TextFormField), 'short');
    await tester.tap(find.byType(MaterialButton));
    await tester.pumpAndSettle();

    expect(find.text(AppLocalizationsEn().passwordShort), findsOneWidget);
    dismissCustomSnackbar();
    await tester.pump();
  });

  testWidgets('a network failure shows the connection message', (tester) async {
    final repo = _FailingResetRepo(const AuthFailure.network());
    await pumpAuthPage(
      tester,
      const ResetPasswordPage(userId: 'u1', secret: 's1'),
      authRepository: repo,
      rootOverlay: true,
    );

    await tester.enterText(find.byType(TextFormField), 'NewPass1!');
    await tester.tap(find.byType(MaterialButton));
    await tester.pumpAndSettle();

    expect(find.text(AppLocalizationsEn().connectionError), findsOneWidget);
    dismissCustomSnackbar();
    await tester.pump();
  });
}

class _FailingResetRepo extends FakeAuthRepository {
  _FailingResetRepo(this.failure) : super(const AuthState.unauthenticated());

  final Object failure;

  @override
  Future<void> completePasswordRecovery({
    required String userId,
    required String secret,
    required String newPassword,
  }) async {
    throw failure;
  }
}
