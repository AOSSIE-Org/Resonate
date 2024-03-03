//import required packages
import 'dart:async';
import 'dart:developer';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/utils/enums/message_type_enum.dart';
import 'package:resonate/views/widgets/snackbar.dart';

//AuthenticationController is used for verifying the text entered in TextFields of email and password and confirm password
class AuthenticationController extends GetxController {
  var isPasswordFieldVisible =
      false.obs; //reactive variable for making password visible and invisible
  var isLoading = false
      .obs; //reactive variable to check for state of AuthenticationController
  TextEditingController emailController = TextEditingController(
      text:
          ""); //TextEditingController for email field with empty string as text
  //any text input field using emailController as its controller will have an empty string initially
  TextEditingController passwordController = TextEditingController(
      text:
          ""); //TextEditingController for password field with empty string as text
  //any text input field using passwordController as its controller will have an empty string initially
  TextEditingController confirmPasswordController = TextEditingController(
      text:
          ""); //TextEditingController for confirm password field with empty string as text
  //any text input field using confirmPasswordController as its controller will have an empty string initially
  AuthStateController authStateController = Get.find<
      AuthStateController>(); //ask get to find AuthStateController from the memory
  //and create an instance of AuthStateController named authStateController

  var loginFormKey; //KEY associated with login form
  var registrationFormKey; //KEY associated with registration form

  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) {
      return;
    }
    try {
      isLoading.value =
          true; //marks the AuthenticationControllers isLoading property to be true
      //call login methof from AuthStateController
      await authStateController.login(
          emailController.text,
          passwordController
              .text); //pass text stored in emailController and passwordController as email and password
    } on AppwriteException catch (e) {
      //if the email and password entered are incorrect then
      //display a customSnackbar() dfined in lib\views\widgets\snackbar.dart
      log(e.toString());
      if (e.type == 'user_invalid_credentials') {
        customSnackbar(
            'Try Again!', "Incorrect Email Or Password", MessageType.error);
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
      //call signup method from AuthStateController as pass text stored in emailController and passwordController
      //as email and password
      await authStateController.signup(
          emailController.text, passwordController.text);
      return true;
    } catch (e) {
      //catch error if any and display the error using customSnackbar() defined in lib\views\widgets\snackbar.dart
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
      //call loginWithGoogle() method of AuthStateController to provide functionality of logging in with Google account
      await authStateController.loginWithGoogle();
    } catch (error) {
      log(error.toString());
    }
  }

  Future<void> loginWithGithub() async {
    try {
      //call loginWithGithub() method of AuthStateController to provide functionality of logging in with Github account
      await authStateController.loginWithGithub();
    } catch (error) {
      log(error.toString());
    }
  }
}

//an extension for validating the text in email and password controller
extension Validator on String {
  bool isValidEmail() {
    //use Regular Expression to check the format of email address
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }

  bool isValidPassword() {
    //use Regular Expression to check the weather password contains
    //a capital letter[A-Z], a small letter[a-z], and a digit[0-9]
    return RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$')
        .hasMatch(this);
  }

  //check if the password entered is same
  bool isSamePassword(String password) {
    return this == password;
  }
}
