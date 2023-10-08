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

  TextEditingController imageController = TextEditingController();


  @override
  void onInit() {
    super.onInit();
    storage = Storage(authStateController.client);
    databases = Databases(authStateController.client);
  }

  Future<void> pickImage() async {
    try {
      isLoading.value = true;

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
      isLoading.value = false;

      // Close the loading dialog
      Get.back();
    }
  }

  Future<void> saveProfile() async {
    try {
      isLoading.value = true;

      // Display Loading Dialog
      Get.dialog(
          Center(
            child: LoadingAnimationWidget.threeRotatingDots(
                color: Colors.amber, size: Get.pixelRatio * 20),
          ),
          barrierDismissible: false,
          name: "Loading Dialog");

      // Create new user profile picture file in Storage
      final profileImage = await storage.createFile(
          bucketId: userProfileImageBucketId,
          fileId: ID.unique(),
          file: InputFile.fromPath(
              path: profileImagePath!,
              filename: "${authStateController.email}.jpeg"));

      imageController.text =
          "$appwriteEndpoint/storage/buckets/$userProfileImageBucketId/files/${profileImage.$id}/view?project=$appwriteProjectId";

      print("profileImage: ${imageController.text}");

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

      // Set user profile in authStateController
      await authStateController.setUserProfileData();
      // Get.snackbar("Saved Successfully", "");

    } catch (e) {
      log(e.toString());
      Get.snackbar("Error!", e.toString());
    } finally {
      isLoading.value = false;

      // Close the loading dialog
      Get.back();
    }
  }
}
