import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/auth/data/repositories/auth_repository.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/profile/data/repositories/profile_repository.dart';
import 'package:resonate/features/profile/model/edit_profile_state.dart';
import 'package:resonate/features/profile/viewmodel/edit_profile_notifier.dart';

import '../../../helpers/test_root_container.dart';
import '../fake_profile_repository.dart';

void main() {
  late FakeProfileRepository repo;
  late FakeAuthRepository auth;
  late ProviderContainer container;

  setUp(() async {
    repo = FakeProfileRepository();
    auth = FakeAuthRepository(
      AuthState.authenticated(
        fakeAuthUser(
          uid: 'u1',
          displayName: 'Test User',
          userName: 'testuser',
          email: 'test@test.com',
          profileImageUrl: 'http://img',
          profileImageID: 'img123',
        ),
      ),
    );
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(auth),
        profileRepositoryProvider.overrideWithValue(repo),
      ],
    );
    addTearDown(container.dispose);
    await container.read(authSessionProvider.future);
  });

  EditProfile notifier() => container.read(editProfileProvider.notifier);

  test('change detectors compare against the signed-in user', () {
    final n = notifier();
    expect(n.isUsernameChanged('newuser'), true);
    expect(n.isUsernameChanged('testuser'), false);
    expect(n.isDisplayNameChanged('New Name'), true);
    expect(n.isDisplayNameChanged('Test User'), false);
  });

  test('isUsernameAvailable forwards the current username', () async {
    repo.usernameAvailableReturn = true;
    final result = await notifier().isUsernameAvailable('whatever');
    expect(result, true);
    expect(repo.isUsernameAvailableArg, 'whatever');
    expect(repo.isUsernameAvailableCurrent, 'testuser');
  });

  test('removeProfilePicture flags removal and clears the picked path', () {
    final n = notifier();
    n.setProfileImagePath('local.jpg');
    expect(container.read(editProfileProvider).profileImagePath, 'local.jpg');
    n.removeProfilePicture();
    final state = container.read(editProfileProvider);
    expect(state.removeImage, true);
    expect(state.profileImagePath, isNull);
  });

  test('isProfilePictureChanged reflects path or remove flag', () {
    final n = notifier();
    expect(n.isProfilePictureChanged(), false);
    n.setProfileImagePath('local.jpg');
    expect(n.isProfilePictureChanged(), true);
  });

  test('saveProfile with no changes is a no-op and does not refresh auth',
      () async {
    final before = auth.loadCount;
    final result = await notifier().saveProfile(
      name: 'Test User',
      username: 'testuser',
    );
    expect(result, EditProfileSaveResult.noChange);
    expect(repo.changeUsernameArgs, isNull);
    expect(repo.updateDisplayNameArgs, isNull);
    expect(auth.loadCount, before); // no DB writes → no auth refresh
  });

  test('saveProfile persists username + display name changes', () async {
    final result = await notifier().saveProfile(
      name: 'New Name',
      username: 'newuser',
    );
    expect(result, EditProfileSaveResult.saved);
    expect(repo.changeUsernameArgs?.oldUsername, 'testuser');
    expect(repo.changeUsernameArgs?.newUsername, 'newuser');
    expect(repo.changeUsernameArgs?.uid, 'u1');
    expect(repo.updateDisplayNameArgs?.name, 'New Name');
    expect(container.read(editProfileProvider).isLoading, false);
  });

  test('saveProfile uploads a new picture and deletes the old one', () async {
    final n = notifier();
    n.setProfileImagePath('local.jpg');
    final result = await n.saveProfile(name: 'Test User', username: 'testuser');

    expect(result, EditProfileSaveResult.saved); 
    expect(repo.deleteProfileImageCount, 1);
    expect(repo.deletedImageId, 'img123');
    expect(repo.uploadProfileImageCount, 1);
    expect(repo.uploadArgs?.imagePath, 'local.jpg');
    expect(repo.updateProfileImageRowArgs?.uid, 'u1');
    // Path cleared after a successful save.
    expect(container.read(editProfileProvider).profileImagePath, isNull);
  });

  test('saveProfile removes the picture: deletes the file then clears the row',
      () async {
    final n = notifier();
    n.removeProfilePicture(); 
    final result = await n.saveProfile(name: 'Test User', username: 'testuser');

    expect(result, EditProfileSaveResult.saved); 
    expect(repo.deleteProfileImageCount, 1);
    expect(repo.deletedImageId, 'img123');
    expect(repo.clearedImageRowUid, 'u1');
    expect(repo.uploadProfileImageCount, 0);
  });
}
