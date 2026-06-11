enum ChangeEmailStatus {
  success,
  emailExists,
  invalidCredentials,
  passwordTooShort,
  failed,
}

// Credential-related failures for ProfileRepository
enum ChangeEmailFailure { invalidCredentials, passwordTooShort, unknown }

// View-model state for the change-email form.
class ChangeEmailState {
  const ChangeEmailState({
    this.isLoading = false,
    this.passwordVisible = false,
  });

  final bool isLoading;
  final bool passwordVisible;

  ChangeEmailState copyWith({bool? isLoading, bool? passwordVisible}) =>
      ChangeEmailState(
        isLoading: isLoading ?? this.isLoading,
        passwordVisible: passwordVisible ?? this.passwordVisible,
      );
}
