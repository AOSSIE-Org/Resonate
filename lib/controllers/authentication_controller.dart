import 'dart:async';
import 'dart:developer';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/utils/enums/message_type_enum.dart';
import 'package:resonate/views/widgets/snackbar.dart';

class AuthenticationController extends GetxController {
  var isPasswordFieldVisible = false.obs;
  var isLoading = false.obs;
  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");
  TextEditingController confirmPasswordController =
      TextEditingController(text: "");
  AuthStateController authStateController = Get.find<AuthStateController>();

  var loginFormKey;
  var registrationFormKey;

  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) {
      return;
    }
    try {
      isLoading.value = true;
      await authStateController.login(
          emailController.text, passwordController.text);
    } on AppwriteException catch (e) {
      log(e.toString());
      if (e.type == 'user_invalid_credentials') {
        customSnackbar('Try Again!', "Incorrect Email Or Password", MessageType.error);
      }
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> signup() async {
    try {
      isLoading.value = true;
      await authStateController.signup(
          emailController.text, passwordController.text);
      return true;
    } catch (e) {
      var error = e.toString().split(": ")[1];
      error = error.split(".")[0];
      error = error.split(",")[1];
      error = error.split("in")[0];
      customSnackbar('Oops', error.toString(), MessageType.error);
      return false;
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

  Future<void> loginWithGithub() async {
    try {
      await authStateController.loginWithGithub();
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
    return RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$')
        .hasMatch(this);
  }

  bool isSamePassword(String password) {
    return this == password;
  }
}
