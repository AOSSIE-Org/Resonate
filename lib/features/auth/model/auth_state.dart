import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:resonate/features/auth/model/auth_user.dart';

part 'generated/auth_state.freezed.dart';

@freezed
sealed class AuthState with _$AuthState {
  const AuthState._();

  // No active Appwrite session.
  const factory AuthState.unauthenticated() = AuthStateUnauthenticated;

  // Session exists but the user has not finished onboarding.
  const factory AuthState.needsOnboarding(AuthUser user) =
      AuthStateNeedsOnboarding;

  // Session exists but the user is blocked (`reportsCount > 5`).
  const factory AuthState.blocked(AuthUser user) = AuthStateBlocked;

  // Fully signed-in and ready to use the app.
  const factory AuthState.authenticated(AuthUser user) =
      AuthStateAuthenticated;

  // True for any state that carries an [AuthUser].
  bool get hasSession => switch (this) {
    AuthStateUnauthenticated() => false,
    _ => true,
  };

  AuthUser? get userOrNull => switch (this) {
    AuthStateNeedsOnboarding(:final user) => user,
    AuthStateBlocked(:final user) => user,
    AuthStateAuthenticated(:final user) => user,
    _ => null,
  };
}
