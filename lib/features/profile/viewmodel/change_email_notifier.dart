import 'package:resonate/features/auth/viewmodel/auth_notifier.dart';
import 'package:resonate/features/profile/data/repositories/profile_repository.dart';
import 'package:resonate/features/profile/model/change_email_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/change_email_notifier.g.dart';

@riverpod
class ChangeEmail extends _$ChangeEmail {
  @override
  ChangeEmailState build() => const ChangeEmailState();

  void togglePasswordVisible() =>
      state = state.copyWith(passwordVisible: !state.passwordVisible);

  Future<ChangeEmailStatus> changeEmail({
    required String email,
    required String password,
  }) async {
    final user = ref.read(authProvider).value?.userOrNull;
    if (user == null) return ChangeEmailStatus.failed;

    final repo = ref.read(profileRepositoryProvider);
    state = state.copyWith(isLoading: true);
    try {
      if (!await repo.isEmailAvailable(email)) {
        return ChangeEmailStatus.emailExists;
      }

      try {
        await repo.changeEmailInAuth(email: email, password: password);
      } on ChangeEmailFailure catch (failure) {
        return switch (failure) {
          ChangeEmailFailure.invalidCredentials =>
            ChangeEmailStatus.invalidCredentials,
          ChangeEmailFailure.passwordTooShort =>
            ChangeEmailStatus.passwordTooShort,
          ChangeEmailFailure.unknown => ChangeEmailStatus.failed,
        };
      }

      await repo.changeEmailInDatabases(
        uid: user.uid,
        username: user.userName ?? '',
        email: email,
      );
      await ref.read(authProvider.notifier).refresh();

      return ChangeEmailStatus.success;
    } catch (_) {
      return ChangeEmailStatus.failed;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
