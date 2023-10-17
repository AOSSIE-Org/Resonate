import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:resonate/controllers/authentication_controller.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/enums/message_type_enum.dart';
import 'package:resonate/views/widgets/snackbar.dart';

import 'auth_state_controller.dart';

class OnboardingController extends GetxController {
  final ImagePicker _imagePicker = ImagePicker();
  AuthStateController authStateController = Get.find<AuthStateController>();
  AuthenticationController authController =
      Get.find<AuthenticationController>();
  late final Storage storage;
  late final Databases databases;

  RxBool isLoading = false.obs;
  String? profileImagePath;
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController imageController =
      TextEditingController(text: userProfileImagePlaceholderUrl);
  TextEditingController dobController = TextEditingController(text: "");

  final GlobalKey<FormState> userOnboardingFormKey = GlobalKey<FormState>();

  Rx<bool> usernameAvailable = false.obs;

  @override
  void onInit() async {
    super.onInit();
    storage = Storage(authStateController.client);
    databases = Databases(authStateController.client);
  }

  Future<void> chooseDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(1800),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      dobController.text =
          DateFormat("dd-MM-yyyy").format(pickedDate).toString();
    }
  }

  Future<void> saveProfile() async {
    if (!userOnboardingFormKey.currentState!.validate()) {
      return;
    }
    var usernameAvail = await isUsernameAvailable(usernameController.text);
    if (!usernameAvail) {
      usernameAvailable.value = false;
      customSnackbar("Username Unavailable!", "This username is invalid or either taken already.", MessageType.error);
      return;
    }
    try {
      isLoading.value = true;

      // Update username collection
      await databases.createDocument(
          databaseId: userDatabaseID,
          collectionId: usernameCollectionID,
          documentId: usernameController.text,
          data: {"email": authStateController.email});
      //Update User Meta Data
      if (profileImagePath != null) {
        final profileImage = await storage.createFile(
            bucketId: userProfileImageBucketId,
            fileId: ID.unique(),
            file: InputFile.fromPath(
                path: profileImagePath!,
                filename: "${authStateController.email}.jpeg"));
        imageController.text =
            "$appwriteEndpoint/storage/buckets/$userProfileImageBucketId/files/${profileImage.$id}/view?project=$appwriteProjectId";
      }

      // Update User meta data
      await authStateController.account.updateName(name: nameController.text);
      await databases.createDocument(
        databaseId: userDatabaseID,
        collectionId: usersCollectionID,
        documentId: authStateController.uid!,
        data: {
          "name": nameController.text,
          "username": usernameController.text,
          "profileImageUrl": imageController.text,
          "dob": dobController.text,
          "email": authStateController.email
        },
      );
      await authStateController.account
          .updatePrefs(prefs: {"isUserProfileComplete": true});

      // Set user profile in authStateController
      await authStateController.setUserProfileData();
      customSnackbar("Saved Successfully", "", MessageType.success);
      Get.toNamed(AppRoutes.tabview);
    } catch (e) {
      log(e.toString());
      customSnackbar("Error!", e.toString(), MessageType.error);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage() async {
    try {
      XFile? file = await _imagePicker.pickImage(
          source: ImageSource.gallery, maxHeight: 400, maxWidth: 400);
      if (file == null) return;
      profileImagePath = file.path;
      update();
    } catch (e) {
      log(e.toString());
    }
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
}
