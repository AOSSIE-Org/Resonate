import 'dart:developer';

import 'package:get/get.dart';

import '../models/user_model.dart';


class ProfileController extends GetxController{
  bool isLoading = false;
  UserProfile userProfile = Get.arguments[0];

  @override
  void onInit() {
    super.onInit();
    log(userProfile.toString());
  }
}