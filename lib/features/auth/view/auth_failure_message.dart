import 'package:resonate/features/auth/model/auth_failure.dart';
import 'package:resonate/l10n/app_localizations.dart';

/// User-facing text for an auth failure.
///
/// `AuthFailure.toString()` renders the Dart class name, so failures must be
/// translated here instead of stringified at the call site.
String authFailureMessage(Object error, AppLocalizations l10n) =>
    switch (error) {
      AuthFailureInvalidCredentials() => l10n.incorrectEmailOrPassword,
      AuthFailurePasswordTooShort() => l10n.passwordShort,
      AuthFailureUserAlreadyExists() => l10n.emailExists,
      AuthFailureNetwork() => l10n.connectionError,
      AuthFailureUnknown(:final message) when message.trim().isNotEmpty =>
        message,
      _ => l10n.tryAgain,
    };
