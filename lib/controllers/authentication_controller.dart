import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:random_string/random_string.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:resonate/utils/constants.dart';

class AuthenticationController extends GetxController {
  var isLoading = false.obs;
  var signup_isallowed = true.obs;
  var resendIsAllowed = false.obs;
  var isVerifying = false.obs;
  var isPasswordFieldVisible = false.obs;
  late TextEditingController emailController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");
  TextEditingController confirmPasswordController =
      TextEditingController(text: "");
  AuthStateController authStateController = Get.find<AuthStateController>();

  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> registrationFormKey = GlobalKey<FormState>();
  late final Functions functions;
  late final Databases databases;
  var verification_ID;

  @override
  void onInit() async {
    super.onInit();
    functions = Functions(authStateController.client);
    databases = Databases(authStateController.client);
  }

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
      Get.snackbar("Oops", error.toString());
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

  Future<bool> sendOTP() async {
    isLoading.value = true;
    var otp_ID = randomNumeric(10).toString() + emailController.text;
    // Appwrite does not accept @ in document ID's
    otp_ID = otp_ID.split("@")[0];
    var sendOtpData = {
      "email": emailController.text,
      "otpID": otp_ID.toString()
    };
    print(otp_ID);
    await authStateController.account.updatePrefs(prefs: {"otp_ID": otp_ID});
    var data = json.encode(sendOtpData);

    await functions.createExecution(
        functionId: sendOtpFunctionID, data: data.toString());
    isLoading.value = false;
    resendIsAllowed.value = false;

    Timer(const Duration(milliseconds: 300), () {
      signup_isallowed.value = true;
    });

    Get.toNamed(AppRoutes.emailVerification);
    return true;
  }

  Future<void> verifyOTP(String userOTP) async {
    verification_ID = randomNumeric(10).toString() + emailController.text;
    verification_ID = verification_ID.split("@")[0];
    var prefs = await authStateController.account.getPrefs();
    var otp_ID = prefs.data['otp_ID'];
    print(otp_ID);
    var verifyOtpData = {
      "otpID": otp_ID,
      "userOTP": userOTP,
      "verify_ID": verification_ID
    };
    var data = json.encode(verifyOtpData);
    await functions.createExecution(
        functionId: verifyOtpFunctionID, data: data.toString());
  }

  Future<String> checkVerificationStatus() async {
    final document = await databases.getDocument(
      databaseId: emailVerificationDatabaseID,
      collectionId: verificationCollectionID,
      documentId: verification_ID,
    );
    var isVerified = document.data['status'];
    return isVerified;
  }

  Future<void> setVerified() async {
    var verifyUserData = {
      "userID": authStateController.uid,
    };
    var verifyData = json.encode(verifyUserData);
    await functions.createExecution(
        functionId: verifyUserFunctionID, data: verifyData.toString());
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
