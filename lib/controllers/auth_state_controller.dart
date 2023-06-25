import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';

class AuthStateContoller extends GetxController{
  Client client = Client();
  late final Account account;
  late String? uid;
  late String? displayName;
  late String? email;
  late String? profileImageUrl;
  late String? userName;

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

  Future<void> setUserProfileData() async{
    User appwriteUser = await account.get();
    displayName = appwriteUser.name;
    email = appwriteUser.email;
    profileImageUrl = appwriteUser.prefs.data["profileImageUrl"];
    uid = appwriteUser.$id;
    userName = appwriteUser.email;
    update();
  }

  Future<void> isUserLoggedIn() async {
    try{
      await setUserProfileData();
      Get.offNamed(AppRoutes.tabview);
    }catch(e){
      log(e.toString());
      Get.toNamed(AppRoutes.login);
    }
  }

  Future<void> login(String email, String password) async {
    await account.createEmailSession(email: email, password: password);
    await setUserProfileData();
  }

  Future<void> signup(String email, String password) async {
    await account.create(userId: ID.unique(), email: email, password: password);
    await account.createEmailSession(email: email, password: password);
    await setUserProfileData();
  }

  Future<void> logout() async{
    await account.deleteSession(sessionId: 'current');
    Get.offNamed(AppRoutes.login);
  }
}