//import required packages
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

//EmailVerifyController is used for verifying the email after account creation
class EmailVerifyController extends GetxController {
  //fields marked as late does not have any data and will receive data in future
  late String verificationID;
  late Execution responseVerify;
  late Execution responseSetVerified;
  late String updateStatus;
  late final Functions functions;
  late final Databases databases;
  //Reactive variables
  var resendIsAllowed = false.obs;
  var isSending = false.obs;
  var isExpanded = true.obs;
  var shouldDisplay = true.obs;
  var isVerifying = false.obs;
  var isUpdateAllowed = true.obs;
  var signupisallowed = true.obs;
  var clearTextField = false.obs;
  AuthStateController authStateController = Get.find<
      AuthStateController>(); //create an instance of AuthStateController defined in lib\controllers\auth_state_controller.dart
  //Get.find is used as controller is already present in the memory
  AuthenticationController authController = Get.find<
      AuthenticationController>(); //create an instance of AuthenticationController defined in lib\controllers\authentication_controller.dart
  TextEditingController updateEmailController = TextEditingController(
      text: ""); //TextEditingController to handel email changes

  @override
  void onInit() async {
    super.onInit();
    //Functions class is provided by appwrite package and allows to access and manage AppWrite cloud
    //Functions class requires an instance of Client class as a parameter
    //we have created an instnce of Client class in AuthStateController
    functions = Functions(authStateController.client);
    //Databases class is also provide by appwrite package and allows working with Databases stores in AppWrite cloud
    //Databases class also requires an instance of Client class as a parameter
    databases = Databases(authStateController.client);
  }

  // Method for sending OTP to the user's email
  Future<bool> sendOTP() async {
    authController.isLoading.value =
        true; //set the value of authController's isLoading reactive variable as true
    var otpID = randomNumeric(10).toString() + authStateController.email!;
    // Appwrite does not accept @ in document ID's
    otpID = otpID.split("@")[0];
    var sendOtpData = {
      "email":
          authStateController.email, //email address to which otp will be sent
      "otpID": otpID.toString() //the unique id associated with the otp.
      //This id contains a random number whose lenght is 10 along with the username of email
    };
    //call updatePrefs() method of Account class of appwrite package
    //updatePrefs() method takes a map of key of string type and value of dynamic type.
    //this function is used to update currently logged in users account preferences
    await authStateController.account
        .updatePrefs(prefs: {"otp_ID": otpID, "isUserProfileComplete": true});
    var data =
        json.encode(sendOtpData); //encode the sendOtpData as json to future use

    //sendOtpFunctionID is a constant and is defined in lib\utils\constants.dart
    //createExecution() uses sendOtpFunctionID to trigger the execution of server side function
    //perform some action on data
    var res = await functions.createExecution(
        functionId: sendOtpFunctionID, data: data.toString());
    //set the value of authController's isLoading reactive variable as false
    authController.isLoading.value = false;
    //if the response received after calling createExecution() is "mail sent"
    if (res.response == '{"message":"mail sent"}') {
      //then set the value of resendIsAllowed reactive variable to false
      //this informs that mail can't be resent
      resendIsAllowed.value = false;
      //after a duration of 300 milliseconds set the value of signupisallowed reactive variable to true
      Timer(const Duration(milliseconds: 300), () {
        //this informs that the user can signup again
        signupisallowed.value = true;
      });
      //set the value of isSending reactive variable to false
      //this informs that the email has been sent
      isSending.value = false;
      //Navigate to emailVerification route which takes user to EmailVerificationScreen()
      Get.toNamed(AppRoutes.emailVerification);
    } else {
      //if any other response is received after calling createExecution() method then
      isSending.value =
          false; //set the value of isSending to false informing that the email has not been sent
      signupisallowed.value =
          true; //set the value of signupisallowed to true informing that user can sign up again
      customSnackbar(
          'Oops',
          res.response,
          MessageType
              .error); //display a customSnackbar() defined in lib\views\widgets\snackbar.dart
    }

    return true;
  }

  //veify the otp entered by the user
  Future<void> verifyOTP(String userOTP) async {
    verificationID = randomNumeric(10).toString() +
        authStateController
            .email!; // Generate a verification ID using a random numeric string and the user's email
    verificationID = verificationID.split("@")[
        0]; //use the first element of array created after splitting verificationID
    var prefs = await authStateController.account
        .getPrefs(); //get the users current preferences by calling getPrefs() method of Account class defined in appwrite package
    var otpId = prefs.data[
        'otp_ID']; //set the value of otpId as the value stored in 'otp_ID' key of `data` map.
    var verifyOtpData = {
      //map of string : dynamic
      "otpID": otpId,
      "userOTP": userOTP,
      "verify_ID": verificationID
    };
    var data = json.encode(verifyOtpData); //encode the verifyOtpData map
    responseVerify = await functions.createExecution(
        //call createExecution() method to trigger a function using
        //verifyOtpFunctionID constant defined in lib\utils\constants.dart
        // to perform some action on data
        functionId: verifyOtpFunctionID,
        data: data.toString());
  }

  //check weather the email is verified or not
  Future<String> checkVerificationStatus() async {
    //access the user document form Appwrite db
    final document = await databases.getDocument(
      //constants from lib\utils\constants.dart
      databaseId: emailVerificationDatabaseID,
      collectionId: verificationCollectionID,
      //String defined in EmailVerifyController
      documentId: verificationID,
    );
    //store the value of 'status' from data map of document in isVerified
    var isVerified = document.data['status'];
    return isVerified; //return the isVerified
  }

  //This method sets the user as verified by calling a server-side function createExecution().
  Future<void> setVerified() async {
    var verifyUserData = {
      "userID": authStateController.uid,
    };
    var verifyData = json.encode(verifyUserData);
    responseSetVerified = await functions.createExecution(
        functionId: verifyUserFunctionID, data: verifyData.toString());
  }

  //This method updates the user's email by calling a server-side function createExecution()
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
