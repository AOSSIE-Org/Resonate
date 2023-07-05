import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:get/get.dart';
import 'package:resonate/utils/constants.dart';

import '../routes/app_routes.dart';

class AuthStateContoller extends GetxController {
  Client client = Client();
  late final Account account;
  late final Databases databases;
  late String? uid;
  late String? displayName;
  late String? email;
  late String? profileImageUrl;
  late String? userName;
  late bool? isUserProfileComplete;

  @override
  void onInit() async {
    super.onInit();
    client
        .setEndpoint(appwriteEndpoint)
        .setProject(appwriteProjectId)
        .setSelfSigned(status: true); // For self signed certificates, only use for development
    account = Account(client);
    databases = Databases(client);
    await setUserProfileData();
  }

  Future<void> setUserProfileData() async {
    try {
      User appwriteUser = await account.get();
      displayName = appwriteUser.name;
      email = appwriteUser.email;
      uid = appwriteUser.$id;
      isUserProfileComplete = appwriteUser.prefs.data["isUserProfileComplete"] ?? false;
      if (isUserProfileComplete==true){
        Document userDataDoc = await databases.getDocument(databaseId: userDatabaseID, collectionId: usersCollectionID, documentId: appwriteUser.$id);
        profileImageUrl = userDataDoc.data["profileImageUrl"];
        userName = userDataDoc.data["username"] ?? "unavailable";
      }
      update();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> isUserLoggedIn() async {
    try {
      await setUserProfileData();
      if (isUserProfileComplete==false) {
        Get.offNamed(AppRoutes.onBoarding);
      } else {
        Get.offNamed(AppRoutes.tabview);
      }
    } catch (e) {
      Get.offNamed(AppRoutes.login);
    }
  }

  Future<void> login(String email, String password) async {
    await account.createEmailSession(email: email, password: password);
    await isUserLoggedIn();
  }

  Future<void> signup(String email, String password) async {
    await account.create(userId: ID.unique(), email: email, password: password);
    await account.createEmailSession(email: email, password: password);
    await setUserProfileData();
  }

  Future<void> loginWithGoogle() async {
    await account.createOAuth2Session(provider: 'google');
    await isUserLoggedIn();
  }

  Future<void> logout() async {
    await account.deleteSession(sessionId: 'current');
    Get.offNamed(AppRoutes.login);
  }
}
