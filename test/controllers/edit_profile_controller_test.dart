import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/controllers/edit_profile_controller.dart';
import 'package:resonate/themes/theme_controller.dart';
import 'package:resonate/utils/constants.dart';
import 'edit_profile_controller_test.mocks.dart';

@GenerateMocks([
  Databases,
  Storage,
  ThemeController,
  Account,
  Client,
  FirebaseMessaging,
])
void main() {
  late MockDatabases databases;
  late EditProfileController editProfileController;
  setUp(() {
    databases = MockDatabases();
    editProfileController = EditProfileController(
      themeController: MockThemeController(),
      authStateController: AuthStateController(
        account: MockAccount(),
        client: MockClient(),
        databases: databases,
        messaging: MockFirebaseMessaging(),
      ),
      storage: MockStorage(),
      databases: databases,
    );
    editProfileController.authStateController.displayName = 'Test User';
    editProfileController.authStateController.userName = 'testuser';
    editProfileController.onInit();

    when(
      databases.getDocument(
        databaseId: userDatabaseID,
        collectionId: usernameCollectionID,
        documentId: 'testuser',
      ),
    ).thenAnswer(
      (_) => Future.value(
        Document(
          $collectionId: usernameCollectionID,
          $databaseId: userDatabaseID,
          $id: 'testuser',
          $createdAt: DateTime.now().toIso8601String(),
          $updatedAt: DateTime.now().toIso8601String(),
          $permissions: ['any'],
          data: {"email": "test@test.com"},
          $sequence: 0,
        ),
      ),
    );
  });

  test('check onInit', () {
    editProfileController.onInit();
    expect(editProfileController.oldDisplayName, 'Test User');
    expect(editProfileController.oldUsername, 'testuser');
    expect(editProfileController.nameController.text, 'Test User');
    expect(editProfileController.usernameController.text, 'testuser');
  });
  test('check isUsernameAvailable', () async {
    final result = await editProfileController.isUsernameAvailable('testuser');
    expect(result, false);
  });

  test('check isUsernameChanged', () {
    editProfileController.usernameController.text = 'newuser';
    final result = editProfileController.isUsernameChanged();
    expect(result, true);
    editProfileController.usernameController.text = 'testuser';
    final result2 = editProfileController.isUsernameChanged();
    expect(result2, false);
  });

  test('check isDisplayNameChanged', () {
    editProfileController.nameController.text = 'New User';
    final result = editProfileController.isDisplayNameChanged();
    expect(result, true);
    editProfileController.nameController.text = 'Test User';
    final result2 = editProfileController.isDisplayNameChanged();
    expect(result2, false);
  });

  test('check removeProfilePicture', () {
    editProfileController.authStateController.profileImageUrl =
        "https://example.com/image.jpg";
    editProfileController.authStateController.profileImageID = "image123";
    editProfileController.removeProfilePicture();
    expect(editProfileController.removeImage, true);
    expect(editProfileController.profileImagePath, null);
  });

  test('check isProfilePictureChanged', () {
    editProfileController.profileImagePath = "path/to/image.jpg";
    final result = editProfileController.isProfilePictureChanged();
    expect(result, true);
    editProfileController.profileImagePath = null;
    final result2 = editProfileController.isProfilePictureChanged();
    expect(result2, false);
    editProfileController.removeImage = true;
    final result3 = editProfileController.isProfilePictureChanged();
    expect(result3, true);
  });

  test('check isThereUnsavedChanges', () {
    editProfileController.nameController.text = 'New User';
    editProfileController.usernameController.text = 'newuser';
    editProfileController.profileImagePath = "path/to/image.jpg";
    final result = editProfileController.isThereUnsavedChanges();
    expect(result, true);

    editProfileController.nameController.text = 'Test User';
    editProfileController.usernameController.text = 'testuser';
    editProfileController.profileImagePath = null;
    final result2 = editProfileController.isThereUnsavedChanges();
    expect(result2, false);
  });
}
