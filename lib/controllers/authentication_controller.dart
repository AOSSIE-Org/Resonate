import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthenticationController extends GetxController {
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void onInit() async {
    super.onInit();
    await isUserLoggedIn();
  }


  Future<void> isUserLoggedIn() async {
    User? firebaseUser = await _auth.currentUser;
    if (firebaseUser != null) {
      Get.offNamed(AppRoutes.profile);
    }else{
      return;
    }
  }

  Future<void> login() async {
    try {
      final UserCredential firebaseUser =
          await _auth.signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
      Get.offNamed(AppRoutes.profile);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> signup() async {
    try {
      final UserCredential firebaseUser =
          await _auth.createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
      Get.offNamed(AppRoutes.profile);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final UserCredential firebaseUser =
          await _auth.signInWithCredential(credential);
      Get.offNamed(AppRoutes.profile);
    } catch (error) {
      log(error.toString());
    }
  }

  Future<void> logout() async {
    User? firebaseUser = _auth.currentUser;
    if ((firebaseUser?.providerData[0].providerId == "google.com")) {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } else {
      await _auth.signOut();
    }
    Get.offNamed(AppRoutes.login);
  }
}
