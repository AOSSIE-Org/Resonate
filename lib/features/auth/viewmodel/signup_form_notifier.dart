import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/signup_form_notifier.g.dart';

class SignupFormState {
  const SignupFormState({
    this.passwordVisible = false,
    this.confirmPasswordVisible = false,
  });

  final bool passwordVisible;
  final bool confirmPasswordVisible;

  SignupFormState copyWith({
    bool? passwordVisible,
    bool? confirmPasswordVisible,
  }) =>
      SignupFormState(
        passwordVisible: passwordVisible ?? this.passwordVisible,
        confirmPasswordVisible:
            confirmPasswordVisible ?? this.confirmPasswordVisible,
      );
}

@riverpod
class SignupForm extends _$SignupForm {
  @override
  SignupFormState build() => const SignupFormState();

  void togglePasswordVisible() {
    state = state.copyWith(passwordVisible: !state.passwordVisible);
  }

  void toggleConfirmPasswordVisible() {
    state = state.copyWith(
      confirmPasswordVisible: !state.confirmPasswordVisible,
    );
  }

  void reset() {
    state = const SignupFormState();
  }
}
