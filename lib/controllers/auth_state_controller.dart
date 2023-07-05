import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:get/get.dart';
import 'package:resonate/utils/constants.dart';

import '../routes/app_routes.dart';

class AuthStateContoller extends GetxController {
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
        .setEndpoint(appwriteEndpoint)
        .setProject(appwriteProjectId)
        .setSelfSigned(
            status:
                true); // For self signed certificates, only use for development
    account = Account(client);
    await setUserProfileData();
    
  }

  Future<void> setUserProfileData() async {
    User appwriteUser = await account.get();
    displayName = appwriteUser.name;
    email = appwriteUser.email;
    profileImageUrl = appwriteUser.prefs.data["profileImageUrl"];
    uid = appwriteUser.$id;
    userName = appwriteUser.prefs.data["username"] ?? "unavailable";
    update();
  }

  Future<void> isUserLoggedIn() async {
    try {
      await setUserProfileData();
      if (profileImageUrl == null) {
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
    await setUserProfileData();
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
