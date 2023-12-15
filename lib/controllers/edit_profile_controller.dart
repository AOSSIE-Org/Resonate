import 'dart:developer';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/services/appwrite_service.dart';
import 'package:resonate/utils/enums/message_type_enum.dart';
import 'package:resonate/views/widgets/snackbar.dart';

import '../utils/constants.dart';
import 'auth_state_controller.dart';

class EditProfileController extends GetxController {
  String? profileImagePath;

  final ImagePicker _imagePicker = ImagePicker();

  AuthStateController authStateController = Get.find<AuthStateController>();

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

    oldDisplayName = authStateController.displayName!;
    oldUsername = authStateController.userName!;

    nameController.text = authStateController.displayName!;
    usernameController.text = authStateController.userName!;
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
    // Display Loading Dialog
    Get.dialog(
      Center(
        child: LoadingAnimationWidget.threeRotatingDots(
          color: Colors.amber,
          size: Get.pixelRatio * 20,
        ),
      ),
      barrierDismissible: false,
      name: "Loading Dialog",
    );

    XFile? file = await _imagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 400,
      maxWidth: 400,
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
      userProfileImagePlaceholderUrl) {
    removeImage = true;
  }
  profileImagePath = null;
  update();
}

Future<void> pickImageFromGallery() async {
  try {
    // Display Loading Dialog
    Get.dialog(
      Center(
        child: LoadingAnimationWidget.threeRotatingDots(
          color: Colors.amber,
          size: Get.pixelRatio * 20,
        ),
      ),
      barrierDismissible: false,
      name: "Loading Dialog",
    );

    XFile? file = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 400,
      maxWidth: 400,
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

Future<File?> _cropImage(String imagePath) async {
  File? croppedFile = await ImageCropper().cropImage(
    sourcePath: imagePath,
    aspectRatioPresets: [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9,
    ],
    androidUiSettings: AndroidUiSettings(
      toolbarColor: Colors.amber,
      statusBarColor: Colors.amber.shade900,
      toolbarWidgetColor: Colors.white,
      cropFrameColor: Colors.amber,
      initAspectRatio: CropAspectRatioPreset.original,
      lockAspectRatio: false,
    ),
    iosUiSettings: IOSUiSettings(
      minimumAspectRatio: 1.0,
    ),
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
    if (usernameController.text == oldUsername) {
      return false;
    }
    return true;
  }

  bool isDisplayNameChanged() {
    if (nameController.text == oldDisplayName) {
      return false;
    }
    return true;
  }

  bool isProfilePictureChanged() {
    if (profileImagePath != null || removeImage) {
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
        imageController.text = userProfileImagePlaceholderUrl;

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
        var usernameAvail = await isUsernameAvailable(usernameController.text);

        if (!usernameAvail) {
          usernameAvailable.value = false;
          customSnackbar(
              "Username Unavailable!",
              "This username is invalid or either taken already.",
              MessageType.error);
          return;
        }

        // Create new doc of New Username
        await databases.createDocument(
          databaseId: userDatabaseID,
          collectionId: usernameCollectionID,
          documentId: usernameController.text,
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
            "username": usernameController.text,
          },
        );
      }

      //Update user DISPLAY-NAME
      if (isDisplayNameChanged()) {
        // Update user DISPLAY-NAME and USERNAME
        await authStateController.account.updateName(name: nameController.text);

        await databases.updateDocument(
          databaseId: userDatabaseID,
          collectionId: usersCollectionID,
          documentId: authStateController.uid!,
          data: {
            "name": nameController.text,
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
        customSnackbar('Profile updated', 'All changes are saved successfully.',
            MessageType.success);
      } else {
        // This snackbar is to show user that profile is up to date and there are no changes done by user
        customSnackbar(
            'Profile is up to date',
            'There are no new changes made, Nothing to save.',
            MessageType.info);
      }
    } catch (e) {
      log(e.toString());
      customSnackbar('Error!', e.toString(), MessageType.error);
    } finally {
      isLoading.value = false;
      showSuccessSnackbar = false;
    }
  }
}
