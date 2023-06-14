import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/enums/gender.dart';

import '../routes/app_routes.dart';

class OnboardingController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Reference _storageRef = FirebaseStorage.instance.ref();
  final ImagePicker _imagePicker = ImagePicker();

  RxBool isLoading = false.obs;
  File? profileImage;
  final User? user = FirebaseAuth.instance.currentUser;

  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController imageController =
      TextEditingController(text: userProfileImagePlaceholderUrl);
  TextEditingController genderController =
      TextEditingController(text: Gender.male.name);
  TextEditingController dobController = TextEditingController(text: "");

  final GlobalKey<FormState> userOnboardingFormKey = GlobalKey<FormState>();

  Rx<bool> usernameAvailable = false.obs;

  @override
  void onInit() async {
    super.onInit();
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

  void setGender(Gender gender) {
    genderController.text = gender.name;
    update();
  }

  Future<void> saveProfile() async {
    if (!userOnboardingFormKey.currentState!.validate()) {
      return;
    }
    var usernameAvail = await isUsernameAvailable(usernameController.text);
    if (!usernameAvail) {
      usernameAvailable.value = false;
      Get.snackbar("Username Unavailable!",
          "This username is invalid or either taken already.",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    try {
      isLoading.value = true;

      // Upload Image placeholder if Image not provided by user
      if (profileImage == null) {
        await _auth.currentUser!.updatePhotoURL(userProfileImagePlaceholderUrl);
        log("Image Placeholder uploaded successfully");
      }

      // Upload profile image to firebase storage if selected one
      if (profileImage != null) {
        final metadata = SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {'picked-file-path': profileImage!.path},
        );
        Reference ref = _storageRef
            .child("users")
            .child(user!.uid)
            .child("profileImage.jpeg");
        UploadTask uploadTask = ref.putFile(profileImage!, metadata);
        await uploadTask.whenComplete(() async {
          imageController.text = await ref.getDownloadURL();
          await _auth.currentUser!.updatePhotoURL(imageController.text);
          log("Image uploaded successfully");
        });
      }

      //Update Firebase auth Display name
      await _auth.currentUser!.updateDisplayName(nameController.text);

      // Update user data on firestore
      await _firestore.collection("users").doc(user!.uid).set({
        "userName": usernameController.text,
        "profileImageUrl": imageController.text,
        "gender": genderController.text,
        "dateOfBirth": dobController.text,
      }, SetOptions(merge: true));

      // Update usernames collection
      await _firestore
          .collection("usernames")
          .doc(usernameController.text)
          .set({"uid": _auth.currentUser!.uid});

      Get.offNamed(AppRoutes.tabview);
    } catch (e) {
      log(e.toString());
      Get.snackbar("Error!", e.toString());
    } finally {
      Get.snackbar("Saved Successfully", "");
      isLoading.value = false;
    }
  }

  Future<void> pickImage() async {
    try {
      XFile? file = await _imagePicker.pickImage(
          source: ImageSource.gallery, maxHeight: 400, maxWidth: 400);
      if (file == null) return;
      profileImage = File(file.path);
      update();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<bool> isUsernameAvailable(String username) async {
    final documentSnapshot = await FirebaseFirestore.instance
        .collection('usernames')
        .doc(username)
        .get();
    return !documentSnapshot.exists;
  }
}
