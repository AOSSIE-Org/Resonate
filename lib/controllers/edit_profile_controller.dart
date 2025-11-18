import 'dart:developer';
import 'package:flutter/semantics.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:resonate/l10n/app_localizations.dart';
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

  final AuthStateController authStateController;

  final ThemeController themeController;
  late final Storage storage;
  late final TablesDB tables;

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

  EditProfileController({
    ThemeController? themeController,
    AuthStateController? authStateController,
    Storage? storage,
    TablesDB? tables,
  }) : themeController = themeController ?? Get.find<ThemeController>(),
       authStateController =
           authStateController ?? Get.find<AuthStateController>(),
       storage = storage ?? AppwriteService.getStorage(),
       tables = tables ?? AppwriteService.getTables();

  @override
  void onInit() {
    super.onInit();
    oldDisplayName = authStateController.displayName!.trim();
    oldUsername = authStateController.userName!.trim();

    nameController.text = authStateController.displayName!.trim();
    usernameController.text = authStateController.userName!.trim();
    log(profileImagePath.toString());
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
    if (authStateController.profileImageUrl != null) {
      removeImage = true;
    }
    log(authStateController.profileImageUrl.toString());
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
          toolbarTitle: AppLocalizations.of(Get.context!)!.cropImage,
          // toolbarColor: themeController.primaryColor.value,
          // statusBarColor: themeController.primaryColor.value,
          // toolbarWidgetColor: Colors.black,
          // cropFrameColor: Colors.white,
          // activeControlsWidgetColor: themeController.primaryColor.value,
        ),
        IOSUiSettings(
          minimumAspectRatio: 1.0,
          title: AppLocalizations.of(Get.context!)!.cropImage,
        ),
      ],
    );

    return croppedFile;
  }

  Future<bool> isUsernameAvailable(String username) async {
    try {
      await tables.getRow(
        databaseId: userDatabaseID,
        tableId: usernameCollectionID,
        rowId: username,
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
            fileId: authStateController.profileImageID!,
          );
        } catch (e) {
          log(e.toString());
        }

        uniqueIdForProfileImage =
            authStateController.uid! +
            DateTime.now().millisecondsSinceEpoch.toString();

        // Create new user profile picture file in Storage
        final profileImage = await storage.createFile(
          bucketId: userProfileImageBucketId,
          fileId: uniqueIdForProfileImage,
          file: InputFile.fromPath(
            path: profileImagePath!,
            filename: "${authStateController.email}.jpeg",
          ),
        );

        imageController.text =
            "$appwriteEndpoint/storage/buckets/$userProfileImageBucketId/files/${profileImage.$id}/view?project=$appwriteProjectId";

        // Update user profile picture URL in Database
        await tables.updateRow(
          databaseId: userDatabaseID,
          tableId: usersCollectionID,
          rowId: authStateController.uid!,
          data: {
            "profileImageUrl": imageController.text,
            "profileImageID": uniqueIdForProfileImage,
          },
        );
      }

      if (removeImage) {
        imageController.text = "";

        // Update user profile picture URL in Database
        await tables.updateRow(
          databaseId: userDatabaseID,
          tableId: usersCollectionID,
          rowId: authStateController.uid!,
          data: {"profileImageUrl": imageController.text},
        );
      }

      // Update USERNAME
      if (isUsernameChanged()) {
        var usernameAvail = await isUsernameAvailable(
          usernameController.text.trim(),
        );
        if (!usernameAvail) {
          usernameAvailable.value = false;
          customSnackbar(
            AppLocalizations.of(Get.context!)!.usernameUnavailable,
            AppLocalizations.of(Get.context!)!.usernameInvalidOrTaken,
            LogType.error,
          );

          SemanticsService.announce(
            AppLocalizations.of(Get.context!)!.usernameInvalidOrTaken,
            TextDirection.ltr,
          );
          return;
        }

        // Create new doc of New Username
        await tables.createRow(
          databaseId: userDatabaseID,
          tableId: usernameCollectionID,
          rowId: usernameController.text.trim(),
          data: {'email': authStateController.email},
        );

        try {
          // Delete Old Username doc, so Username can be re-usable
          await tables.deleteRow(
            databaseId: userDatabaseID,
            tableId: usernameCollectionID,
            rowId: oldUsername,
          );
        } catch (e) {
          log(e.toString());
        }

        await tables.updateRow(
          databaseId: userDatabaseID,
          tableId: usersCollectionID,
          rowId: authStateController.uid!,
          data: {"username": usernameController.text.trim()},
        );
      }

      //Update user DISPLAY-NAME
      if (isDisplayNameChanged()) {
        // Update user DISPLAY-NAME and USERNAME
        await authStateController.account.updateName(
          name: nameController.text.trim(),
        );

        await tables.updateRow(
          databaseId: userDatabaseID,
          tableId: usersCollectionID,
          rowId: authStateController.uid!,
          data: {"name": nameController.text.trim()},
        );
      }

      // Set user profile in authStateController
      await authStateController.setUserProfileData();

      // Change all old values with new values
      oldDisplayName = authStateController.displayName!;
      oldUsername = authStateController.userName!;

      removeImage = false;
      profileImagePath =
          null; // The Success snackbar is only shown when there is change made, otherwise it is not shown
      if (showSuccessSnackbar) {
        customSnackbar(
          AppLocalizations.of(Get.context!)!.profileSavedSuccessfully,
          AppLocalizations.of(Get.context!)!.profileUpdatedSuccessfully,
          LogType.success,
        );

        SemanticsService.announce(
          AppLocalizations.of(Get.context!)!.profileUpdatedSuccessfully,
          TextDirection.ltr,
        );
      } else {
        // This snackbar is to show user that profile is up to date and there are no changes done by user
        customSnackbar(
          AppLocalizations.of(Get.context!)!.profileUpToDate,
          AppLocalizations.of(Get.context!)!.noChangesToSave,
          LogType.info,
        );

        SemanticsService.announce(
          AppLocalizations.of(Get.context!)!.noChangesToSave,
          TextDirection.ltr,
        );
      }
    } catch (e) {
      log(e.toString());
      customSnackbar(
        AppLocalizations.of(Get.context!)!.error,
        e.toString(),
        LogType.error,
      );

      SemanticsService.announce(e.toString(), TextDirection.ltr);
    } finally {
      isLoading.value = false;
      showSuccessSnackbar = false;
    }
  }
}
