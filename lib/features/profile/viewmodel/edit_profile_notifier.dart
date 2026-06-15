import 'package:resonate/features/auth/viewmodel/auth_notifier.dart';
import 'package:resonate/features/profile/data/repositories/profile_repository.dart';
import 'package:resonate/features/profile/model/edit_profile_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/edit_profile_notifier.g.dart';

@riverpod
class EditProfile extends _$EditProfile {
  @override
  EditProfileState build() => const EditProfileState();

  void setUsernameChecking(bool value) =>
      state = state.copyWith(usernameChecking: value);

  void setUsernameAvailable(bool value) =>
      state = state.copyWith(usernameAvailable: value);

  void setProfileImagePath(String path) =>
      state = state.copyWith(profileImagePath: path, removeImage: false);

  void removeProfilePicture() {
    final user = ref.read(authProvider).value?.userOrNull;
    state = state.copyWith(
      removeImage: user?.profileImageUrl != null,
      clearProfileImagePath: true,
    );
  }

  Future<bool> isUsernameAvailable(String username) {
    final user = ref.read(authProvider).value?.userOrNull;
    return ref.read(profileRepositoryProvider).isUsernameAvailable(
          username,
          currentUsername: user?.userName,
        );
  }

  bool isDisplayNameChanged(String name) {
    final user = ref.read(authProvider).value?.userOrNull;
    return name.trim() != (user?.displayName ?? '').trim();
  }

  bool isUsernameChanged(String username) {
    final user = ref.read(authProvider).value?.userOrNull;
    return username.trim() != (user?.userName ?? '').trim();
  }

  bool isProfilePictureChanged() =>
      state.profileImagePath != null || state.removeImage;

  Future<EditProfileSaveResult> saveProfile({
    required String name,
    required String username,
  }) async {
    final user = ref.read(authProvider).value?.userOrNull;
    if (user == null) return EditProfileSaveResult.noChange;

    final repo = ref.read(profileRepositoryProvider);
    final trimmedName = name.trim();
    final trimmedUsername = username.trim();

    final pictureChanged = isProfilePictureChanged();
    final usernameChanged = isUsernameChanged(username);
    final displayNameChanged = isDisplayNameChanged(name);
    final changed = pictureChanged || usernameChanged || displayNameChanged;

    state = state.copyWith(isLoading: true);
    try {
      if (state.profileImagePath != null) {
        if (user.profileImageID != null) {
          await repo.deleteProfileImage(user.profileImageID!);
        }
        final uploaded = await repo.uploadProfileImage(
          uid: user.uid,
          email: user.email,
          imagePath: state.profileImagePath!,
        );
        await repo.updateProfileImageRow(
          uid: user.uid,
          url: uploaded.url,
          id: uploaded.id,
        );
      }

      if (state.removeImage) {
        if (user.profileImageID != null) {
          await repo.deleteProfileImage(user.profileImageID!);
        }
        await repo.clearProfileImageRow(user.uid);
      }

      if (usernameChanged) {
        await repo.changeUsername(
          uid: user.uid,
          email: user.email,
          oldUsername: (user.userName ?? '').trim(),
          newUsername: trimmedUsername,
        );
      }

      if (displayNameChanged) {
        await repo.updateDisplayName(uid: user.uid, name: trimmedName);
      }
      if (changed) {
        await ref.read(authProvider.notifier).refresh();
      }

      state = state.copyWith(
        isLoading: false,
        removeImage: false,
        clearProfileImagePath: true,
      );
      return changed
          ? EditProfileSaveResult.saved
          : EditProfileSaveResult.noChange;
    } catch (_) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }
}
