import 'dart:async';
import 'dart:developer';
import 'package:appwrite/appwrite.dart';
import 'package:resonate/services/appwrite_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/enums/message_type_enum.dart';
import 'package:resonate/views/widgets/snackbar.dart';

class AuthenticationController extends GetxController {
  var isPasswordFieldVisible = false.obs;
  var isConfirmPasswordFieldVisible = false.obs;
  var isLoading = false.obs;
  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");
  TextEditingController confirmPasswordController =
      TextEditingController(text: "");
  AuthStateController authStateController = Get.find<AuthStateController>();

  late GlobalKey<FormState> loginFormKey;
  late GlobalKey<FormState> registrationFormKey;

  Future<void> login() async {
    try {
      isLoading.value = true;
      await authStateController.login(
          emailController.text, passwordController.text);
      emailController.clear();
      passwordController.clear();
    } on AppwriteException catch (e) {
      log(e.toString());
      if (e.type == userInvalidCredentials) {
        customSnackbar(
            'Try Again!', "Incorrect Email Or Password", MessageType.error);
      } else if (e.type == generalArgumentInvalid) {
        customSnackbar('Try Again!', "Password is less than 8 characters",
            MessageType.error);
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

  Future<void> resetPassword(String email) async {
    try {
      print('Email before validation: $email');
      if (!email.isValidEmail()) {
        print('Invalid email address');
        return;
      }

      var account = AppwriteService.getAccount();
      await account.createRecovery(
        email: email,
        url:
            'https://localhost/reset-password', // Replace with actual reset password URL
      );
      customSnackbar(
          'Success', 'Password reset email sent!', MessageType.success);
      //Get.toNamed(AppRoutes.resetPassword); To navigate to resetPassword screen on clicking the link
    } on AppwriteException catch (e) {
      print('Error during password reset: ${e.message}');
      customSnackbar('Error', e.message.toString(), MessageType.error);
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
