import 'package:resonate/features/auth/data/repositories/auth_repository.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/interests/model/interest.dart';
import 'package:resonate/features/profile/data/repositories/profile_repository.dart';
import 'package:resonate/features/profile/model/onboarding_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/onboarding_notifier.g.dart';

@riverpod
class Onboarding extends _$Onboarding {
  @override
  OnboardingState build() => const OnboardingState();

  void setProfileImagePath(String path) =>
      state = state.copyWith(profileImagePath: path);

  void setUsernameChecking(bool value) =>
      state = state.copyWith(usernameChecking: value);

  void setUsernameAvailable(bool value) =>
      state = state.copyWith(usernameAvailable: value);

  bool toggleInterest(Interest interest) {
    final interests = {...state.interests};
    if (!interests.remove(interest)) {
      if (interests.length >= Interest.maxSelectable) return false;
      interests.add(interest);
    }
    state = state.copyWith(interests: interests);
    return true;
  }

  Future<bool> isUsernameAvailable(String username) =>
      ref.read(profileRepositoryProvider).isUsernameAvailable(username);

  Future<OnboardingResult> saveProfile({
    required String name,
    required String username,
    required String dob,
    required String fallbackImageUrl,
  }) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return const OnboardingResult(OnboardingStatus.error);

    final repo = ref.read(profileRepositoryProvider);

    if (!await repo.isUsernameAvailable(username.trim())) {
      state = state.copyWith(usernameAvailable: false);
      return OnboardingResult.usernameUnavailable;
    }

    state = state.copyWith(isLoading: true);
    try {
      await repo.createUsernameRow(username: username.trim(), email: user.email);

      String imageUrl;
      String? imageId;
      if (state.profileImagePath != null) {
        final uploaded = await repo.uploadProfileImage(
          uid: user.uid,
          email: user.email,
          imagePath: state.profileImagePath!,
        );
        imageUrl = uploaded.url;
        imageId = uploaded.id;
      } else {
        imageUrl = fallbackImageUrl;
      }

      await repo.updateAccountName(name.trim());
      await repo.createUserRow(
        uid: user.uid,
        name: name.trim(),
        username: username.trim(),
        profileImageUrl: imageUrl,
        dob: dob,
        email: user.email,
        profileImageID: imageId,
        interests: state.interests.toList(),
      );
      await repo.markProfileComplete();
      await ref.read(authRepositoryProvider).refresh();
      return OnboardingResult.success;
    } catch (e) {
      if (e.toString().contains('Invalid `documentId` param')) {
        return OnboardingResult.invalidUsernameFormat;
      }
      return OnboardingResult(OnboardingStatus.error, e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
