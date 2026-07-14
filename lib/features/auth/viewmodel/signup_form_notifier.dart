import 'package:resonate/features/auth/data/repositories/auth_repository.dart';
import 'package:resonate/features/auth/model/password_strength.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/signup_form_notifier.g.dart';

class SignupFormState {
  const SignupFormState({
    this.passwordVisible = false,
    this.confirmPasswordVisible = false,
    this.strength = PasswordStrength.empty,
    this.signupAllowed = true,
  });

  final bool passwordVisible;
  final bool confirmPasswordVisible;
  final PasswordStrength strength;
  final bool signupAllowed;

  SignupFormState copyWith({
    bool? passwordVisible,
    bool? confirmPasswordVisible,
    PasswordStrength? strength,
    bool? signupAllowed,
  }) =>
      SignupFormState(
        passwordVisible: passwordVisible ?? this.passwordVisible,
        confirmPasswordVisible:
            confirmPasswordVisible ?? this.confirmPasswordVisible,
        strength: strength ?? this.strength,
        signupAllowed: signupAllowed ?? this.signupAllowed,
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

  void checkPassword(String password) {
    state = state.copyWith(strength: PasswordStrength.evaluate(password));
  }

  void blockSignup() => state = state.copyWith(signupAllowed: false);

  void allowSignup() => state = state.copyWith(signupAllowed: true);

  Future<void> signup({required String email, required String password}) =>
      ref
          .read(authRepositoryProvider)
          .signup(email: email, password: password);
}
