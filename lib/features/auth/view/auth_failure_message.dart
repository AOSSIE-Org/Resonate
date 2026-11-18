import 'package:resonate/features/auth/model/auth_failure.dart';
import 'package:resonate/l10n/app_localizations.dart';

/// Narrows a caught error to an [AuthFailure].
AuthFailure asAuthFailure(Object error) =>
    error is AuthFailure ? error : const AuthFailure.unknown('');

/// User-facing text for an auth failure.
String authFailureMessage(AuthFailure error, AppLocalizations l10n) =>
    switch (error) {
      AuthFailureInvalidCredentials() => l10n.incorrectEmailOrPassword,
      AuthFailurePasswordTooShort() => l10n.passwordShort,
      AuthFailureUserAlreadyExists() => l10n.emailExists,
      AuthFailureNetwork() => l10n.connectionError,
      AuthFailureUnknown() => l10n.tryAgain,
    };
