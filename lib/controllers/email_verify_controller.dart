import 'dart:async';
import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:random_string/random_string.dart';
import 'package:resonate/controllers/authentication_controller.dart';

import '../routes/app_routes.dart';
import '../utils/constants.dart';
import 'auth_state_controller.dart';

class EmailVerifyController extends GetxController {
  var isSending = false.obs;
  var pressed = true.obs;
  var shouldDisplay = true.obs;
  late String verificationID;
  late Execution responseVerify;
  late Execution responseSetVerified;
  var resendIsAllowed = false.obs;
  late String status;
  var isVerifying = false.obs;
  var isUpdateAllowed = true.obs;
  late final Functions functions;
  late final Databases databases;
  AuthStateController authStateController = Get.find<AuthStateController>();
  AuthenticationController authController =
      Get.find<AuthenticationController>();
  TextEditingController updateEmailController = TextEditingController(text: "");
  var signupisallowed = true.obs;
  @override
  void onInit() async {
    super.onInit();
    functions = Functions(authStateController.client);
    databases = Databases(authStateController.client);
  }

  Future<bool> sendOTP() async {
    authController.isLoading.value = true;
    var otp_ID = randomNumeric(10).toString() + authStateController.email!;
    // Appwrite does not accept @ in document ID's
    otp_ID = otp_ID.split("@")[0];
    print(authStateController.email);
    var sendOtpData = {
      "email": authStateController.email,
      "otpID": otp_ID.toString()
    };
    await authStateController.account
        .updatePrefs(prefs: {"otp_ID": otp_ID, "isUserProfileComplete": true});
    var data = json.encode(sendOtpData);

    var res = await functions.createExecution(
        functionId: sendOtpFunctionID, data: data.toString());
    authController.isLoading.value = false;
    if (res.response == '{"message":"null"}') {
      resendIsAllowed.value = false;

      Timer(const Duration(milliseconds: 300), () {
        signupisallowed.value = true;
      });
      isSending.value = false;
      Get.toNamed(AppRoutes.emailVerification);
    } else {
      isSending.value = false;
      signupisallowed.value = true;
      Get.snackbar('Oops', res.response);
    }

    return true;
  }

  Future<void> verifyOTP(String userOTP) async {
    verificationID = randomNumeric(10).toString() + authStateController.email!;
    verificationID = verificationID.split("@")[0];
    var prefs = await authStateController.account.getPrefs();
    var otp_ID = prefs.data['otp_ID'];
    var verifyOtpData = {
      "otpID": otp_ID,
      "userOTP": userOTP,
      "verify_ID": verificationID
    };
    var data = json.encode(verifyOtpData);
    responseVerify = await functions.createExecution(
        functionId: verifyOtpFunctionID, data: data.toString());
  }

  Future<String> checkVerificationStatus() async {
    final document = await databases.getDocument(
      databaseId: emailVerificationDatabaseID,
      collectionId: verificationCollectionID,
      documentId: verificationID,
    );
    var isVerified = document.data['status'];
    return isVerified;
  }

  Future<void> setVerified() async {
    var verifyUserData = {
      "userID": authStateController.uid,
    };
    var verifyData = json.encode(verifyUserData);
    responseSetVerified = await functions.createExecution(
        functionId: verifyUserFunctionID, data: verifyData.toString());
  }

  Future<void> updateEmail() async {
    var updateEmailData = json.encode({
      "User_ID": authStateController.uid,
      "email": updateEmailController.text
    });
    var results = await functions.createExecution(
        functionId: updateEmailFunctionID, data: updateEmailData.toString());
    status = results.status;
  }
}
