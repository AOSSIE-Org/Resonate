enum OnboardingStatus {
  success,
  usernameUnavailable,
  invalidUsernameFormat,
  error,
}

class OnboardingResult {
  const OnboardingResult(this.status, [this.message]);

  final OnboardingStatus status;
  final String? message;

  static const success = OnboardingResult(OnboardingStatus.success);
  static const usernameUnavailable = OnboardingResult(
    OnboardingStatus.usernameUnavailable,
  );
  static const invalidUsernameFormat = OnboardingResult(
    OnboardingStatus.invalidUsernameFormat,
  );
}

// View-model state for the onboarding form.
class OnboardingState {
  const OnboardingState({
    this.isLoading = false,
    this.profileImagePath,
    this.usernameAvailable = false,
    this.usernameChecking = false,
  });

  final bool isLoading;
  final String? profileImagePath;
  final bool usernameAvailable;
  final bool usernameChecking;

  OnboardingState copyWith({
    bool? isLoading,
    String? profileImagePath,
    bool? usernameAvailable,
    bool? usernameChecking,
    bool clearProfileImagePath = false,
  }) => OnboardingState(
    isLoading: isLoading ?? this.isLoading,
    profileImagePath: clearProfileImagePath
        ? null
        : (profileImagePath ?? this.profileImagePath),
    usernameAvailable: usernameAvailable ?? this.usernameAvailable,
    usernameChecking: usernameChecking ?? this.usernameChecking,
  );
}
