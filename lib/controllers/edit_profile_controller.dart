import 'dart:developer';
import 'package:flutter/semantics.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resonate/services/appwrite_service.dart';
import 'package:resonate/themes/theme_controller.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/views/widgets/snackbar.dart';

import '../utils/constants.dart';
import 'auth_state_controller.dart';

class EditProfileController extends GetxController {
  String? profileImagePath;

  final ImagePicker _imagePicker = ImagePicker();

  final AuthStateController authStateController =
      Get.find<AuthStateController>();

  final ThemeController themeController = Get.find<ThemeController>();

  // final ThemeController themeController = Get.find<ThemeController>();
  late final Storage storage;
  late final Databases databases;

  RxBool isLoading = false.obs;
  Rx<bool> usernameAvailable = false.obs;

  bool removeImage = false;
  bool showSuccessSnackbar = false;

  late String oldUsername;
  late String oldDisplayName;
  late String uniqueIdForProfileImage;

  TextEditingController imageController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  final GlobalKey<FormState> editProfileFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();

    storage = AppwriteService.getStorage();
    databases = AppwriteService.getDatabases();

    oldDisplayName = authStateController.displayName!.trim();
    oldUsername = authStateController.userName!.trim();

    nameController.text = authStateController.displayName!.trim();
    usernameController.text = authStateController.userName!.trim();
  }

  bool isThereUnsavedChanges() {
    if (isProfilePictureChanged() ||
        isUsernameChanged() ||
        isDisplayNameChanged()) {
      return true;
    }
    return false;
  }

  Future<void> pickImageFromCamera() async {
    try {
      XFile? file = await _imagePicker.pickImage(
        source: ImageSource.camera,
        // maxHeight: 400,
        // maxWidth: 400,
      );

      if (file == null) return;

      // Crop the image
      final croppedFile = await _cropImage(file.path);

      if (croppedFile != null) {
        profileImagePath = croppedFile.path;
        update();
        removeImage = false;
      }
    } catch (e) {
      log(e.toString());
    } finally {
      // Close the loading dialog
      Get.back();
    }
  }

  void removeProfilePicture() {
    if (authStateController.profileImageUrl !=
        themeController.userProfileImagePlaceholderUrl.value) {
      removeImage = true;
    }
    profileImagePath = null;
    update();
  }

  Future<void> pickImageFromGallery() async {
    try {
      XFile? file = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        // maxHeight: 400,
        // maxWidth: 400,
      );

      if (file == null) return;

      // Crop the image
      final croppedFile = await _cropImage(file.path);

      if (croppedFile != null) {
        profileImagePath = croppedFile.path;
        update();
        removeImage = false;
      }
    } catch (e) {
      log(e.toString());
    } finally {
      // Close the loading dialog
      Get.back();
    }
  }

  Future<CroppedFile?> _cropImage(String imagePath) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          // toolbarColor: themeController.primaryColor.value,
          // statusBarColor: themeController.primaryColor.value,
          // toolbarWidgetColor: Colors.black,
          // cropFrameColor: Colors.white,
          // activeControlsWidgetColor: themeController.primaryColor.value,
        ),
        IOSUiSettings(
          minimumAspectRatio: 1.0,
          title: 'Crop Image',
        ),
      ],
    );

    return croppedFile;
  }

  Future<bool> isUsernameAvailable(String username) async {
    try {
      await databases.getDocument(
        databaseId: userDatabaseID,
        collectionId: usernameCollectionID,
        documentId: username,
      );
      return false;
    } catch (e) {
      log(e.toString());
      return true;
    }
  }

  bool isUsernameChanged() {
    if (usernameController.text.trim() == oldUsername) {
      return false;
    }
    return true;
  }

  bool isDisplayNameChanged() {
    if (nameController.text.trim() == oldDisplayName) {
      return false;
    }
    return true;
  }

  bool isProfilePictureChanged() {
    if ((profileImagePath != null) || removeImage) {
      return true;
    }
    return false;
  }

  Future<void> saveProfile() async {
    if (!editProfileFormKey.currentState!.validate()) {
      return;
    }

    if (isProfilePictureChanged() ||
        isUsernameChanged() ||
        isDisplayNameChanged()) {
      showSuccessSnackbar = true;
    }

    try {
      isLoading.value = true;

      // Update user PROFILE PICTURE
      if (profileImagePath != null) {
        try {
          await storage.deleteFile(
              bucketId: userProfileImageBucketId,
              fileId: authStateController.profileImageID!);
        } catch (e) {
          log(e.toString());
        }

        uniqueIdForProfileImage = authStateController.uid! +
            DateTime.now().millisecondsSinceEpoch.toString();

        // Create new user profile picture file in Storage
        final profileImage = await storage.createFile(
            bucketId: userProfileImageBucketId,
            fileId: uniqueIdForProfileImage,
            file: InputFile.fromPath(
                path: profileImagePath!,
                filename: "${authStateController.email}.jpeg"));

        imageController.text =
            "$appwriteEndpoint/storage/buckets/$userProfileImageBucketId/files/${profileImage.$id}/view?project=$appwriteProjectId";

        // Update user profile picture URL in Database
        await databases.updateDocument(
          databaseId: userDatabaseID,
          collectionId: usersCollectionID,
          documentId: authStateController.uid!,
          data: {
            "profileImageUrl": imageController.text,
            "profileImageID": uniqueIdForProfileImage,
          },
        );
      }

      if (removeImage) {
        imageController.text =
            themeController.userProfileImagePlaceholderUrl.value;

        // Update user profile picture URL in Database
        await databases.updateDocument(
          databaseId: userDatabaseID,
          collectionId: usersCollectionID,
          documentId: authStateController.uid!,
          data: {
            "profileImageUrl": imageController.text,
          },
        );
      }

      // Update USERNAME
      if (isUsernameChanged()) {
        var usernameAvail =
            await isUsernameAvailable(usernameController.text.trim());

        if (!usernameAvail) {
          usernameAvailable.value = false;
          customSnackbar(
            "Username Unavailable!",
            "This username is invalid or either taken already.",
            LogType.error,
          );

          SemanticsService.announce(
            "This username is invalid or either taken already.",
            TextDirection.ltr,
          );
          return;
        }

        // Create new doc of New Username
        await databases.createDocument(
          databaseId: userDatabaseID,
          collectionId: usernameCollectionID,
          documentId: usernameController.text.trim(),
          data: {
            'email': authStateController.email,
          },
        );

        try {
          // Delete Old Username doc, so Username can be re-usable
          await databases.deleteDocument(
            databaseId: userDatabaseID,
            collectionId: usernameCollectionID,
            documentId: oldUsername,
          );
        } catch (e) {
          log(e.toString());
        }

        await databases.updateDocument(
          databaseId: userDatabaseID,
          collectionId: usersCollectionID,
          documentId: authStateController.uid!,
          data: {
            "username": usernameController.text.trim(),
          },
        );
      }

      //Update user DISPLAY-NAME
      if (isDisplayNameChanged()) {
        // Update user DISPLAY-NAME and USERNAME
        await authStateController.account
            .updateName(name: nameController.text.trim());

        await databases.updateDocument(
          databaseId: userDatabaseID,
          collectionId: usersCollectionID,
          documentId: authStateController.uid!,
          data: {
            "name": nameController.text.trim(),
          },
        );
      }

      // Set user profile in authStateController
      await authStateController.setUserProfileData();

      // Change all old values with new values
      oldDisplayName = authStateController.displayName!;
      oldUsername = authStateController.userName!;

      removeImage = false;
      profileImagePath = null;

      // The Success snackbar is only shown when there is change made, otherwise it is not shown
      if (showSuccessSnackbar) {
        customSnackbar(
          'Profile updated',
          'All changes are saved successfully.',
          LogType.success,
        );

        SemanticsService.announce(
          'All changes are saved successfully.',
          TextDirection.ltr,
        );
      } else {
        // This snackbar is to show user that profile is up to date and there are no changes done by user
        customSnackbar(
          'Profile is up to date',
          'There are no new changes made, Nothing to save.',
          LogType.info,
        );

        SemanticsService.announce(
          'There are no new changes made, Nothing to save.',
          TextDirection.ltr,
        );
      }
    } catch (e) {
      log(e.toString());
      customSnackbar(
        'Error!',
        e.toString(),
        LogType.error,
      );

      SemanticsService.announce(
        e.toString(),
        TextDirection.ltr,
      );
    } finally {
      isLoading.value = false;
      showSuccessSnackbar = false;
    }
  }
}
