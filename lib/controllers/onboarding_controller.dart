//import required packages
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

//OnboardingController is responsible for displaying the onboarding screens to the user on first login
class OnboardingController extends GetxController {
  final ImagePicker _imagePicker = ImagePicker();
  AuthStateController authStateController = Get.find<AuthStateController>(); //create an instance of AuthStateController
  AuthenticationController authController =
      Get.find<AuthenticationController>(); //create an instance of AuthenticationController
  late final Storage storage; //create an instance of Storage class to connect to AppWrite storage bucket
  late final Databases databases; //create an instance of Database class to connect to AppWrite database

  RxBool isLoading = false.obs; //reactive bool to indicate state of controller
  String? profileImagePath; //url to users profile image
  String? uniqueIdForProfileImage; //unique id associated with users profile image
  TextEditingController nameController = TextEditingController(); //TextEditingController for storing users name
  TextEditingController usernameController = TextEditingController(); //TextEditingController for storing users username
  TextEditingController imageController =
      TextEditingController(text: userProfileImagePlaceholderUrl); //TextEditingController for storing users profile image
      //the imageController will have userProfileImagePlaceholderUrl text by default
  TextEditingController dobController = TextEditingController(text: ""); //TextEditingController for storing users date of birth

  final GlobalKey<FormState> userOnboardingFormKey = GlobalKey<FormState>(); //Form key used in validating form

  Rx<bool> usernameAvailable = false.obs; //reactive bool informing about username availability

  @override
  void onInit() async {
    super.onInit();
    storage = Storage(authStateController.client); //connect to AppWrite storage bucket
    databases = Databases(authStateController.client); //connect to AppWrite storage database
  }
  //function displaying date picker provided by flutters material package
  //User can set his DOB using chooseDate() function
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
  
  //saveProfile() method update the users profile information
  //and saves the updated information to AppWrite servers
  Future<void> saveProfile() async {
    if (!userOnboardingFormKey.currentState!.validate()) {
      return;
    }
    var usernameAvail = await isUsernameAvailable(usernameController.text);
    //is the username is not available then display customSnackbar() defined in lib/views/widgets/snackbar.dart
    if (!usernameAvail) {
      usernameAvailable.value = false;
      customSnackbar(
          "Username Unavailable!",
          "This username is invalid or either taken already.",
          MessageType.error);
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
        uniqueIdForProfileImage = authStateController.uid! +
            DateTime.now().millisecondsSinceEpoch.toString();

        final profileImage = await storage.createFile(
            bucketId: userProfileImageBucketId,
            fileId: uniqueIdForProfileImage!,
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
          "email": authStateController.email,
          "profileImageID": uniqueIdForProfileImage,
        },
      );
      await authStateController.account.updatePrefs(prefs: {
        "isUserProfileComplete": true
      });
      // Set user profile in authStateController
      await authStateController.setUserProfileData();
      customSnackbar("Profile created successfully",
          "Your user profile is successfully created.", MessageType.success);
      Get.toNamed(AppRoutes.tabview);
    } catch (e) {
      log(e.toString());
      customSnackbar("Error!", e.toString(), MessageType.error);
    } finally {
      isLoading.value = false;
    }
  }

  //allows the user to choose image from gallery and 
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

  //checks for username availability by searching for similar usernames in database
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
