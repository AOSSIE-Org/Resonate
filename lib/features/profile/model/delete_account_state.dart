// View-model state for the delete-account screen.
class DeleteAccountState {
  const DeleteAccountState({this.confirmed = false, this.isDeleting = false});

  // The user has typed their own username back, which is what arms the button.
  final bool confirmed;
  final bool isDeleting;

  bool get canDelete => confirmed && !isDeleting;

  DeleteAccountState copyWith({bool? confirmed, bool? isDeleting}) =>
      DeleteAccountState(
        confirmed: confirmed ?? this.confirmed,
        isDeleting: isDeleting ?? this.isDeleting,
      );
}
