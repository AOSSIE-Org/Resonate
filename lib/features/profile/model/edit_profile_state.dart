enum EditProfileSaveResult { saved, noChange }

class EditProfileState {
  const EditProfileState({
    this.isLoading = false,
    this.usernameAvailable = true,
    this.usernameChecking = false,
    this.profileImagePath,
    this.removeImage = false,
  });

  final bool isLoading;
  final bool usernameAvailable;
  final bool usernameChecking;
  final String? profileImagePath;
  final bool removeImage;

  EditProfileState copyWith({
    bool? isLoading,
    bool? usernameAvailable,
    bool? usernameChecking,
    String? profileImagePath,
    bool? removeImage,
    bool clearProfileImagePath = false,
  }) => EditProfileState(
    isLoading: isLoading ?? this.isLoading,
    usernameAvailable: usernameAvailable ?? this.usernameAvailable,
    usernameChecking: usernameChecking ?? this.usernameChecking,
    profileImagePath: clearProfileImagePath
        ? null
        : (profileImagePath ?? this.profileImagePath),
    removeImage: removeImage ?? this.removeImage,
  );
}
