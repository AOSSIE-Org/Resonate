import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/routes/app_routes.dart';

class AuthenticationController extends GetxController {
  var isLoading = false.obs;

  var isPasswordFieldVisible = false.obs;
  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");
  TextEditingController confirmPasswordController = TextEditingController(text: "");

  AuthStateController authStateController = Get.find<AuthStateController>();

  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> registrationFormKey = GlobalKey<FormState>();


  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) {
      return;
    }
    try {
      isLoading.value = true;
      await authStateController.login(emailController.text, passwordController.text);
    } on AppwriteException catch (e) {
      log(e.toString());
      if (e.type == 'user_invalid_credentials') {
        Get.snackbar(
          'Try Again!',
          "Incorrect Email Or Password",
          icon: const Icon(Icons.disabled_by_default_outlined),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signup() async {
    if (!registrationFormKey.currentState!.validate()) {
      return;
    }
    try {
      isLoading.value = true;
      await authStateController.signup(emailController.text, passwordController.text);
      Get.offNamed(AppRoutes.onBoarding);
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      await authStateController.loginWithGoogle();
    } catch (error) {
      log(error.toString());
    }
  }
}

extension Validator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }

  bool isValidPassword() {
    return RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$').hasMatch(this);
  }

  bool isSamePassword(String password) {
    return this == password;
  }
}
