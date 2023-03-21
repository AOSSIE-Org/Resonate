import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:resonate/routes/app_routes.dart';


class AuthenticationController extends GetxController{
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late Auth0 auth0;
  UserProfile? userProfile;

  @override
  void onInit() {
    super.onInit();
    auth0 = Auth0("dev-5w4x3qxvszw8f0u6.us.auth0.com", "4uYaXmTa00TbAZ8WLTQkxAusQAZ8HS0O");
  }

  Future<void> login() async{
    try{
      final Credentials credentials = await auth0.api.login(
          usernameOrEmail: emailController.text,
          password: passwordController.text,
          connectionOrRealm: 'Username-Password-Authentication'
      );
      await auth0.credentialsManager.storeCredentials(credentials);
      print(credentials.user.email);
      userProfile = credentials.user;
      Get.offNamed(AppRoutes.profile, arguments: [userProfile]);
    }
    catch (e) {
      print(e);
    }
  }

  Future<void> signup() async{
    try{
      final DatabaseUser credentials = await auth0.api.signup(
          email: emailController.text,
          password: passwordController.text,
          connection: 'Username-Password-Authentication'
      );
      print(credentials.email);
      print(credentials.isEmailVerified);
      Get.toNamed(AppRoutes.emailVerification);
    }
    catch (e) {
      print(e);
    }
  }
}