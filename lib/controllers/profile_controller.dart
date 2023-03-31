import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:resonate/models/User.dart';
import 'package:resonate/routes/app_routes.dart';


class ProfileController extends GetxController{
  bool isLoading = false;
  User userProfile = Get.arguments[0];

  @override
  void onInit() {
    super.onInit();
    print("User");
    print(userProfile.toString());
  }
}