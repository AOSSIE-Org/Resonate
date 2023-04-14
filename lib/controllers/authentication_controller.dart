import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:resonate/utils/enums/signed_in_by.dart';

import '../models/user_model.dart';

class AuthenticationController extends GetxController {
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  UserProfile? user;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> login() async {
    try {
      final UserCredential firebaseUser = await _auth.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
      user = UserProfile(
          name: firebaseUser.user?.displayName,
          email: firebaseUser.user?.email,
          phoneNumber: firebaseUser.user?.phoneNumber,
          signedInBy: SignedInBy.email);
      Get.offNamed(AppRoutes.profile, arguments: [user]);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> signup() async {
    try {
      final UserCredential firebaseUser = await _auth.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text);
      user = UserProfile(
          name: firebaseUser.user?.displayName,
          email: firebaseUser.user?.email,
          phoneNumber: firebaseUser.user?.phoneNumber,
          signedInBy: SignedInBy.email);
      Get.offNamed(AppRoutes.profile, arguments: [user]);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final UserCredential firebaseUser = await _auth.signInWithCredential(credential);
      user = UserProfile(
          name: firebaseUser.user?.displayName,
          email: firebaseUser.user?.email,
          pictureUrl: firebaseUser.user?.photoURL,
          phoneNumber: firebaseUser.user?.phoneNumber,
          signedInBy: SignedInBy.google
      );
      Get.offNamed(AppRoutes.profile, arguments: [user]);
    } catch (error) {
      log(error.toString());
    }
  }

  Future<void> logout() async {
    if (user?.signedInBy == SignedInBy.google) {
      await _googleSignIn.signOut();
      await _auth.signOut();
    }else if (user?.signedInBy == SignedInBy.email) {
      await _auth.signOut();
    }
    Get.offNamed(AppRoutes.login);
  }
}
