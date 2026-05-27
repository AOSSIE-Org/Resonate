import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/controllers/edit_profile_controller.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/themes/theme_controller.dart';
import 'package:resonate/utils/constants.dart';

import '../helpers/test_root_container.dart';
import 'edit_profile_controller_test.mocks.dart';

@GenerateMocks([TablesDB, Storage, ThemeController])
void main() {
  late EditProfileController editProfileController;
  late MockTablesDB mockTablesDB;

  setUp(() async {
    // Install a test root container with an authenticated user that matches
    // the data the original tests assumed.
    await installTestRootContainer(
      authState: AuthState.authenticated(
        fakeAuthUser(
          displayName: 'Test User',
          userName: 'testuser',
          profileImageUrl: 'https://example.com/image.jpg',
          profileImageID: 'image123',
        ),
      ),
    );

    mockTablesDB = MockTablesDB();
    editProfileController = EditProfileController(
      themeController: MockThemeController(),
      storage: MockStorage(),
      tables: mockTablesDB,
    );
    editProfileController.onInit();

    // Current user's own username → row exists → DB returns it.
    when(
      mockTablesDB.getRow(
        databaseId: userDatabaseID,
        tableId: usernameTableID,
        rowId: 'testuser',
      ),
    ).thenAnswer(
      (_) async => Row(
        $id: 'testuser',
        $tableId: usernameTableID,
        $databaseId: userDatabaseID,
        $createdAt: DateTime.now().toIso8601String(),
        $updatedAt: DateTime.now().toIso8601String(),
        $permissions: ['any'],
        $sequence: 0,
        data: {'email': 'test@test.com'},
      ),
    );
    // A different username that is taken by someone else.
    when(
      mockTablesDB.getRow(
        databaseId: userDatabaseID,
        tableId: usernameTableID,
        rowId: 'anotheruser',
      ),
    ).thenAnswer(
      (_) async => Row(
        $id: 'anotheruser',
        $tableId: usernameTableID,
        $databaseId: userDatabaseID,
        $createdAt: DateTime.now().toIso8601String(),
        $updatedAt: DateTime.now().toIso8601String(),
        $permissions: ['any'],
        $sequence: 0,
        data: {'email': 'another@test.com'},
      ),
    );
  });

  test('onInit copies displayName and userName from auth state', () {
    editProfileController.onInit();
    expect(editProfileController.oldDisplayName, 'Test User');
    expect(editProfileController.oldUsername, 'testuser');
    expect(editProfileController.nameController.text, 'Test User');
    expect(editProfileController.usernameController.text, 'testuser');
  });

  test('isUsernameAvailable: own username true, taken username false',
      () async {
    expect(await editProfileController.isUsernameAvailable('testuser'), true);
    expect(
      await editProfileController.isUsernameAvailable('anotheruser'),
      false,
    );
  });

  test('isUsernameChanged compares against the original username', () {
    editProfileController.usernameController.text = 'newuser';
    expect(editProfileController.isUsernameChanged(), true);
    editProfileController.usernameController.text = 'testuser';
    expect(editProfileController.isUsernameChanged(), false);
  });

  test('isDisplayNameChanged compares against the original display name', () {
    editProfileController.nameController.text = 'New User';
    expect(editProfileController.isDisplayNameChanged(), true);
    editProfileController.nameController.text = 'Test User';
    expect(editProfileController.isDisplayNameChanged(), false);
  });

  test(
    'removeProfilePicture sets removeImage=true and clears profileImagePath',
    () {
      // The auth user installed in setUp already has a profileImageUrl, so
      // removeProfilePicture should flip removeImage to true.
      editProfileController.removeProfilePicture();
      expect(editProfileController.removeImage, true);
      expect(editProfileController.profileImagePath, null);
    },
  );

  test('isProfilePictureChanged: path set OR removeImage flag', () {
    editProfileController.profileImagePath = 'path/to/image.jpg';
    expect(editProfileController.isProfilePictureChanged(), true);

    editProfileController.profileImagePath = null;
    editProfileController.removeImage = false;
    expect(editProfileController.isProfilePictureChanged(), false);

    editProfileController.removeImage = true;
    expect(editProfileController.isProfilePictureChanged(), true);
  });

  test('isThereUnsavedChanges aggregates the three change checks', () {
    editProfileController.nameController.text = 'New User';
    editProfileController.usernameController.text = 'newuser';
    editProfileController.profileImagePath = 'path/to/image.jpg';
    expect(editProfileController.isThereUnsavedChanges(), true);

    editProfileController.nameController.text = 'Test User';
    editProfileController.usernameController.text = 'testuser';
    editProfileController.profileImagePath = null;
    editProfileController.removeImage = false;
    expect(editProfileController.isThereUnsavedChanges(), false);
  });
}
