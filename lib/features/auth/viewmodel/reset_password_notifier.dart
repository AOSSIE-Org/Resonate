import 'package:resonate/features/auth/data/repositories/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/reset_password_notifier.g.dart';

@riverpod
class ResetPassword extends _$ResetPassword {
  @override
  AsyncValue<bool> build() => const AsyncData(false);

  Future<bool> resetPassword({
    required String userId,
    required String secret,
    required String newPassword,
  }) async {
    state = const AsyncLoading<bool>();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).completePasswordRecovery(
            userId: userId,
            secret: secret,
            newPassword: newPassword,
          );
      return true;
    });
    return state.value ?? false;
  }
}
