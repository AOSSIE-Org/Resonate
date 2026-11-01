import 'package:resonate/features/interests/model/interest.dart';

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
    this.interests = const <Interest>{},
  });

  final bool isLoading;
  final String? profileImagePath;
  final bool usernameAvailable;
  final bool usernameChecking;

  // Optional by design: the user may finish onboarding without picking any.
  final Set<Interest> interests;

  OnboardingState copyWith({
    bool? isLoading,
    String? profileImagePath,
    bool? usernameAvailable,
    bool? usernameChecking,
    Set<Interest>? interests,
    bool clearProfileImagePath = false,
  }) => OnboardingState(
    isLoading: isLoading ?? this.isLoading,
    profileImagePath: clearProfileImagePath
        ? null
        : (profileImagePath ?? this.profileImagePath),
    usernameAvailable: usernameAvailable ?? this.usernameAvailable,
    usernameChecking: usernameChecking ?? this.usernameChecking,
    interests: interests ?? this.interests,
  );
}
