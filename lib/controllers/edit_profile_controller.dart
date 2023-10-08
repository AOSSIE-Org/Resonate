import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'auth_state_controller.dart';

class EditProfileController extends GetxController{

  final ImagePicker _imagePicker = ImagePicker();

  AuthStateController authStateController = Get.find<AuthStateController>();

  late final Storage storage;
  late final Databases databases;

  String? profileImagePath;

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
      XFile? file = await _imagePicker.pickImage(source: ImageSource.gallery, maxHeight: 400, maxWidth: 400);
      if (file == null) return;
      profileImagePath = file.path;
      update();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> saveProfile() async {}

}