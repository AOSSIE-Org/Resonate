import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:resonate/models/User.dart';
import 'package:resonate/routes/app_routes.dart';
import 'dart:io' show Platform;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/enums/signed_in_by.dart';

class AuthenticationController extends GetxController {
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late Auth0 auth0;
  late GoogleSignIn googleSignIn;
  UserProfile? userProfile;
  User? user;

  @override
  void onInit() {
    super.onInit();
    auth0 = Auth0("dev-5w4x3qxvszw8f0u6.us.auth0.com",
        "4uYaXmTa00TbAZ8WLTQkxAusQAZ8HS0O");
    googleSignIn = (Platform.isAndroid)
        ? GoogleSignIn(clientId: gcpClientId)
        : GoogleSignIn(clientId: gcpClientId);
  }

  Future<void> login() async {
    try {
      final Credentials credentials = await auth0.api.login(
          usernameOrEmail: emailController.text,
          password: passwordController.text,
          connectionOrRealm: 'Username-Password-Authentication');
      await auth0.credentialsManager.storeCredentials(credentials);
      print(credentials.user.email);
      userProfile = credentials.user;

      user = User(
          name: credentials.user.name,
          email: credentials.user.email,
          phoneNumber: credentials.user.phoneNumber,
          pictureUrl: credentials.user.pictureUrl.toString(),
          signedInBy: SignedInBy.email);
      Get.offNamed(AppRoutes.profile, arguments: [user]);
    } catch (e) {
      print(e);
    }
  }

  Future<void> signup() async {
    try {
      final DatabaseUser credentials = await auth0.api.signup(
          email: emailController.text,
          password: passwordController.text,
          connection: 'Username-Password-Authentication');
      print(credentials.email);
      print(credentials.isEmailVerified);
      Get.toNamed(AppRoutes.emailVerification);
    } catch (e) {
      print(e);
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      print(googleUser?.displayName!);
      user = User(
        name: googleUser?.displayName,
        email: googleUser?.email,
        pictureUrl: googleUser?.photoUrl,
        signedInBy: SignedInBy.google,
      );
      Get.offNamed(AppRoutes.profile, arguments: [user]);
    } catch (error) {
      print(error);
    }
  }

  Future<void> logout() async {
    if (user?.signedInBy == SignedInBy.google) {
      await googleSignIn.signOut();
    }
    Get.offNamed(AppRoutes.login);
  }
}
