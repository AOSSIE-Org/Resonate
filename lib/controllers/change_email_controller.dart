import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/services/appwrite_service.dart';

import '../utils/constants.dart';
import '../utils/enums/message_type_enum.dart';
import '../views/widgets/snackbar.dart';

class ChangeEmailController extends GetxController {
  final authStateController = Get.put(AuthStateController());

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  RxBool isPasswordFieldVisible = false.obs;
  RxBool isLoading = false.obs;

  final changeEmailFormKey = GlobalKey<FormState>();

  late final Databases databases;
  late final Account account;

  @override
  void onInit() {
    super.onInit();

    emailController.text = authStateController.email!;

    databases = AppwriteService.getDatabases();
    account = AppwriteService.getAccount();
  }

  Future<bool> isEmailAvailable(String changedEmail) async {
    final docs = await databases.listDocuments(
      databaseId: userDatabaseID,
      collectionId: usernameCollectionID,
      queries: [
        Query.equal('email', changedEmail),
      ],
    );

    if (docs.total > 0) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> changeEmailInDatabases(String changedEmail) async {
    try {
      // change in user info collection
      await databases.updateDocument(
        databaseId: userDatabaseID,
        collectionId: usersCollectionID,
        documentId: authStateController.uid!,
        data: {
          'email': changedEmail,
        },
      );

      // change in username - email collection
      await databases.updateDocument(
        databaseId: userDatabaseID,
        collectionId: usernameCollectionID,
        documentId: authStateController.userName!,
        data: {
          'email': changedEmail,
        },
      );

      // Set user profile in authStateController
      await authStateController.setUserProfileData();

      return true;
    } on AppwriteException catch (e) {
      log(e.toString());
      customSnackbar('Try Again!', e.toString(), MessageType.error);

      return false;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> changeEmailInAuth(String changedEmail, String password) async {
    try {
      // change in auth section
      await account.updateEmail(
        email: changedEmail,
        password: password,
      );

      return true;
    } on AppwriteException catch (e) {
      log(e.toString());
      if (e.type == userInvalidCredentials) {
        customSnackbar(
            'Try Again!', "Incorrect Email Or Password", MessageType.error);
      } else if (e.type == generalArgumentInvalid) {
        customSnackbar('Try Again!', "Password is less than 8 characters",
            MessageType.error);
      }

      return false;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<void> changeEmail() async {
    if (changeEmailFormKey.currentState!.validate()) {
      isLoading.value = true;

      isEmailAvailable(emailController.text).then((status) {
        if (status) {
          changeEmailInAuth(emailController.text, passwordController.text)
              .then((status) {
            if (status) {
              changeEmailInDatabases(emailController.text).then((status) {
                isLoading.value = false;

                if (status) {
                  customSnackbar('Email Changed', 'Email changed successfully.',
                      MessageType.success);
                } else {
                  customSnackbar(
                      'Failed', 'Failed to change email.', MessageType.error);
                }
              });
            } else {
              isLoading.value = false;
            }
          });
        } else {
          customSnackbar(
              'Oops', 'Email address already exists.', MessageType.error);
          isLoading.value = false;
        }
      });
    }
  }
}
