import 'package:resonate/features/auth/data/repositories/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/login_form_notifier.g.dart';

class LoginFormState {
  const LoginFormState({this.passwordVisible = false});

  final bool passwordVisible;

  LoginFormState copyWith({bool? passwordVisible}) => LoginFormState(
        passwordVisible: passwordVisible ?? this.passwordVisible,
      );
}

@riverpod
class LoginForm extends _$LoginForm {
  @override
  LoginFormState build() => const LoginFormState();

  void togglePasswordVisible() {
    state = state.copyWith(passwordVisible: !state.passwordVisible);
  }

  void reset() {
    state = const LoginFormState();
  }

  Future<void> login({required String email, required String password}) =>
      ref.read(authRepositoryProvider).loginWithEmail(email: email, password: password);
}
