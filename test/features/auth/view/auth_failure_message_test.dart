import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/auth/model/auth_failure.dart';
import 'package:resonate/features/auth/view/auth_failure_message.dart';
import 'package:resonate/l10n/app_localizations_en.dart';

void main() {
  final l10n = AppLocalizationsEn();

  group('authFailureMessage', () {
    test('maps each known failure to localized copy', () {
      expect(
        authFailureMessage(const AuthFailure.invalidCredentials(), l10n),
        l10n.incorrectEmailOrPassword,
      );
      expect(
        authFailureMessage(const AuthFailure.passwordTooShort(), l10n),
        l10n.passwordShort,
      );
      expect(
        authFailureMessage(const AuthFailure.userAlreadyExists(), l10n),
        l10n.emailExists,
      );
      expect(
        authFailureMessage(const AuthFailure.network(), l10n),
        l10n.connectionError,
      );
    });

    test('keeps the server message for unknown failures', () {
      expect(
        authFailureMessage(
          const AuthFailure.unknown('The requested user could not be found.'),
          l10n,
        ),
        'The requested user could not be found.',
      );
    });

    test('never exposes the failure class name', () {
      const failures = [
        AuthFailure.invalidCredentials(),
        AuthFailure.passwordTooShort(),
        AuthFailure.userAlreadyExists(),
        AuthFailure.network(),
        AuthFailure.unknown(''),
      ];

      for (final failure in failures) {
        expect(
          authFailureMessage(failure, l10n),
          isNot(contains('AuthFailure')),
        );
      }
    });

    test('falls back to try again for blank or non-auth errors', () {
      expect(
        authFailureMessage(const AuthFailure.unknown('  '), l10n),
        l10n.tryAgain,
      );
      expect(authFailureMessage(StateError('boom'), l10n), l10n.tryAgain);
    });
  });
}
