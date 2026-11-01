import 'package:resonate/features/auth/data/repositories/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/forgot_password_notifier.g.dart';

@riverpod
class ForgotPassword extends _$ForgotPassword {
  @override
  AsyncValue<bool> build() => const AsyncData(false);

  Future<bool> sendRecoveryEmail({
    required String email,
    required String redirectUrl,
  }) async {
    state = const AsyncLoading<bool>();
    state = await AsyncValue.guard(() async {
      await ref
          .read(authRepositoryProvider)
          .sendPasswordRecovery(email: email, redirectUrl: redirectUrl);
      return true;
    });
    return state.value ?? false;
  }
}
