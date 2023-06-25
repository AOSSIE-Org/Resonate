import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';

class AuthStateContoller extends GetxController{
  Client client = Client();
  late final Account account;

  @override
  void onInit() async {
    super.onInit();
    client
        .setEndpoint('http://localhost/v1')
        .setProject('648c22fd861787e6f32c')
        .setSelfSigned(status: true); // For self signed certificates, only use for development
    account = Account(client);
    await isUserLoggedIn();
  }

  Future<void> isUserLoggedIn() async {
    try{
      User appwriteUser = await account.get();
      print(appwriteUser.name);
      Get.offNamed(AppRoutes.tabview);
    }catch(e){
      log(e.toString());
      Get.toNamed(AppRoutes.login);
    }
  }

  Future<void> login(String email, String password) async {
    await account.createEmailSession(email: email, password: password);
  }

  Future<void> logout() async{
    await account.deleteSession(sessionId: 'current');
    Get.offNamed(AppRoutes.login);
  }
}