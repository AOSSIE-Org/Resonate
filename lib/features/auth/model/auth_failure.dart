import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/auth_failure.freezed.dart';

@freezed
sealed class AuthFailure with _$AuthFailure {
  const factory AuthFailure.invalidCredentials() = AuthFailureInvalidCredentials;
  const factory AuthFailure.passwordTooShort() = AuthFailurePasswordTooShort;
  const factory AuthFailure.userAlreadyExists() = AuthFailureUserAlreadyExists;
  const factory AuthFailure.network() = AuthFailureNetwork;
  const factory AuthFailure.unknown(String message) = AuthFailureUnknown;
}
