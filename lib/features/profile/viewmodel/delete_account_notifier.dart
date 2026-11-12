import 'package:resonate/features/auth/data/repositories/auth_repository.dart';
import 'package:resonate/features/profile/model/delete_account_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/delete_account_notifier.g.dart';

@riverpod
class DeleteAccount extends _$DeleteAccount {
  @override
  DeleteAccountState build() => const DeleteAccountState();

  void setButtonActive(bool value) =>
      state = state.copyWith(confirmed: value);

  // Returns whether the account went. The caller is the one that can route
  // away and say so, which it should only do on a true.
  Future<bool> deleteAccount() async {
    if (!state.canDelete) return false;
    state = state.copyWith(isDeleting: true);
    try {
      await ref.read(authRepositoryProvider).deleteAccount();
      return true;
    } catch (_) {
      // Left armed so the user can try again without retyping.
      if (ref.mounted) state = state.copyWith(isDeleting: false);
      return false;
    }
  }
}
