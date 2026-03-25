import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/services/appwrite_service.dart';
import 'package:resonate/utils/constants.dart';

class DeleteAccountController extends GetxController {
  RxBool isButtonActive = false.obs;

  AuthStateController authStateController = Get.put(AuthStateController());

  late final Storage storage;
  late final TablesDB tables;

  //
  //-------------------------------------------------------------------
  //        PLEASE DO NOT TOUCH THIS CODE WITHOUT PERMISSION          -
  //-------------------------------------------------------------------
  //

  @override
  void onInit() {
    super.onInit();

    storage = AppwriteService.getStorage();
    tables = AppwriteService.getTables();
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
}
