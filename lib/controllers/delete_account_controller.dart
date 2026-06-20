import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:resonate/services/appwrite_service.dart';
import 'package:resonate/utils/constants.dart';

class DeleteAccountController extends GetxController {
  RxBool isButtonActive = false.obs;
  RxBool isLoading = false.obs;

  AuthStateController authStateController = Get.put(AuthStateController());

  late final Storage storage;
  late final TablesDB tables;
  late final Account account;

  @override
  void onInit() {
    super.onInit();

    storage = AppwriteService.getStorage();
    tables = AppwriteService.getTables();
    account = AppwriteService.getAccount();
  }

  Future<void> deleteUserProfilePicture() async {
    try {
      await storage.deleteFile(
        bucketId: userProfileImageBucketId,
        fileId: authStateController.profileImageID!,
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> deleteUsernamesCollectionDocument() async {
    try {
      await tables.deleteRow(
        databaseId: userDatabaseID,
        tableId: usernameTableID,
        rowId: authStateController.userName!,
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> deleteUsersCollectionDocument() async {
    try {
      await tables.deleteRow(
        databaseId: userDatabaseID,
        tableId: usersTableID,
        rowId: authStateController.uid!,
      );
    } catch (e) {
      log(e.toString());
    }
  }

  /// Permanently removes all user data and blocks the auth account,
  /// then redirects to the welcome screen.
  Future<void> deleteAccount() async {
    try {
      isLoading.value = true;

      // Delete all associated user data
      await deleteUserProfilePicture();
      await deleteUsernamesCollectionDocument();
      await deleteUsersCollectionDocument();

      // Block the auth account so the user can no longer log in.
      // The Appwrite client SDK does not expose a hard-delete endpoint;
      // updateStatus() permanently blocks the account from any access.
      await account.updateStatus();

      // Invalidate all active sessions
      await account.deleteSessions();

      Get.offAllNamed(AppRoutes.welcomeScreen);
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
