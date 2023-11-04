import 'dart:async';
import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:random_string/random_string.dart';
import 'package:resonate/controllers/authentication_controller.dart';
import 'package:resonate/utils/enums/message_type_enum.dart';
import 'package:resonate/views/widgets/snackbar.dart';
import '../routes/app_routes.dart';
import '../utils/constants.dart';
import 'auth_state_controller.dart';

class EmailVerifyController extends GetxController {
  late String verificationID;
  late Execution responseVerify;
  late Execution responseSetVerified;
  late String updateStatus;
  late final Functions functions;
  late final Databases databases;
  var resendIsAllowed = false.obs;
  var isSending = false.obs;
  var isExpanded = true.obs;
  var shouldDisplay = true.obs;
  var isVerifying = false.obs;
  var isUpdateAllowed = true.obs;
  var signupisallowed = true.obs;
  var clearTextField=false.obs;
  AuthStateController authStateController = Get.find<AuthStateController>();
  AuthenticationController authController =
      Get.find<AuthenticationController>();
  TextEditingController updateEmailController = TextEditingController(text: "");

  @override
  void onInit() async {
    super.onInit();
    functions = Functions(authStateController.client);
    databases = Databases(authStateController.client);
  }

  Future<bool> sendOTP() async {
    authController.isLoading.value = true;
    var otpID = randomNumeric(10).toString() + authStateController.email!;
    // Appwrite does not accept @ in document ID's
    otpID = otpID.split("@")[0];
    var sendOtpData = {
      "email": authStateController.email,
      "otpID": otpID.toString()
    };

    await authStateController.account
        .updatePrefs(prefs: {"otp_ID": otpID, "isUserProfileComplete": true});
    var data = json.encode(sendOtpData);

    var res = await functions.createExecution(
        functionId: sendOtpFunctionID, data: data.toString());

    authController.isLoading.value = false;

    if (res.response == '{"message":"mail sent"}') {
      resendIsAllowed.value = false;

      Timer(const Duration(milliseconds: 300), () {
        signupisallowed.value = true;
      });
      isSending.value = false;
      Get.toNamed(AppRoutes.emailVerification);
    } else {
      isSending.value = false;
      signupisallowed.value = true;
      customSnackbar('Oops', res.response, MessageType.error);
    }

    return true;
  }

  Future<void> verifyOTP(String userOTP) async {
    verificationID = randomNumeric(10).toString() + authStateController.email!;
    verificationID = verificationID.split("@")[0];
    var prefs = await authStateController.account.getPrefs();
    var otpId = prefs.data['otp_ID'];
    var verifyOtpData = {
      "otpID": otpId,
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
    updateStatus = results.status;
  }
}
