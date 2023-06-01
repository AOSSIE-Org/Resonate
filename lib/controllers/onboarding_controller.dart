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

  @override
  void onInit() {
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
    try {
      isLoading.value = true;

      // Upload profile image to firebase storage
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

      // Update user data on firestore
      await _auth.currentUser!.updateDisplayName(nameController.text);
      await _firestore.collection("users").doc(user!.uid).set({
        "username": usernameController.text,
        "profileImageUrl": imageController.text,
        "gender": genderController.text,
        "dateOfBirth": dobController.text,
      }, SetOptions(merge: true));

      //TODO: Navigate to dashboard/home screen
      Get.snackbar("Saved Successfully", "");
    } catch (e) {
      log(e.toString());
      Get.snackbar("Error!", e.toString());
    } finally {
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
}
