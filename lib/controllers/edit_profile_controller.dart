import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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

  late String oldUsername;
  late String oldDisplayName;

  TextEditingController imageController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  final GlobalKey<FormState> editProfileFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    storage = Storage(authStateController.client);
    databases = Databases(authStateController.client);

    oldDisplayName = authStateController.displayName!;
    oldUsername = authStateController.userName!;

    nameController.text = authStateController.displayName!;
    usernameController.text = authStateController.userName!;
  }

  Future<void> pickImage() async {
    try {
      // Display Loading Dialog
      Get.dialog(
          Center(
            child: LoadingAnimationWidget.threeRotatingDots(
                color: Colors.amber, size: Get.pixelRatio * 20),
          ),
          barrierDismissible: false,
          name: "Loading Dialog");

      XFile? file = await _imagePicker.pickImage(
          source: ImageSource.gallery, maxHeight: 400, maxWidth: 400);
      if (file == null) return;
      profileImagePath = file.path;
      update();
    } catch (e) {
      log(e.toString());
    } finally {
      // Close the loading dialog
      Get.back();
    }
  }

  Future<bool> isUsernameAvailable(String username) async {
    try {
      await databases.getDocument(
        databaseId: userDatabaseID,
        collectionId: usernameCollectionID,
        documentId: username,
      );
      print('gotit');
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

  Future<void> saveProfile() async {
    if (!editProfileFormKey.currentState!.validate()) {
      return;
    }

    try {
      isLoading.value = true;

      // Update user PROFILE PICTURE
      if (profileImagePath != null) {
        // Create new user profile picture file in Storage
        final profileImage = await storage.createFile(
            bucketId: userProfileImageBucketId,
            fileId: ID.unique(),
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
            // "name": nameController.text,
            // "username": usernameController.text,
            "profileImageUrl": imageController.text,
            // "dob": dobController.text,
            // "email": authStateController.email
          },
        );
      }

      // Update USERNAME
      if (isUsernameChanged()) {
        var usernameAvail = await isUsernameAvailable(usernameController.text);

        if (!usernameAvail) {
          usernameAvailable.value = false;
          Get.snackbar(
            "Username Unavailable!",
            "This username is invalid or either taken already.",
          );
          return;
        }
        print(oldUsername);

        // Delete Old Username doc, so Username can be re-usable
        await databases.deleteDocument(
          databaseId: userDatabaseID,
          collectionId: usernameCollectionID,
          documentId: oldUsername,
        );

        // Create new doc of New Username
        await databases.createDocument(
          databaseId: userDatabaseID,
          collectionId: usernameCollectionID,
          documentId: usernameController.text,
          data: {
            'email': authStateController.email,
          },
        );

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
    } catch (e) {
      log(e.toString());
      Get.snackbar("Error!", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
