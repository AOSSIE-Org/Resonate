import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/semantics.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/services/appwrite_service.dart';

import '../utils/constants.dart';
import '../utils/enums/log_type.dart';
import '../views/widgets/snackbar.dart';
import 'package:resonate/l10n/app_localizations.dart';

class ChangeEmailController extends GetxController {
  final AuthStateController authStateController;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  ChangeEmailController({
    AuthStateController? authStateController,
    TablesDB? tables,
    Account? account,
  }) : authStateController =
           authStateController ?? Get.find<AuthStateController>(),
       tables = tables ?? AppwriteService.getTables(),
       account = account ?? AppwriteService.getAccount();

  RxBool isPasswordFieldVisible = false.obs;
  RxBool isLoading = false.obs;

  final changeEmailFormKey = GlobalKey<FormState>();

  late final TablesDB tables;
  late final Account account;

  Future<bool> isEmailAvailable(String changedEmail) async {
    final docs = await tables.listRows(
      databaseId: userDatabaseID,
      tableId: usernameTableID,
      queries: [
        Query.equal('email', changedEmail),
        Query.select(["*"]),
      ],
    );

    if (docs.total > 0) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> changeEmailInDatabases(
    String changedEmail,
    BuildContext context,
  ) async {
    try {
      // change in user info collection
      await tables.updateRow(
        databaseId: userDatabaseID,
        tableId: usersTableID,
        rowId: authStateController.uid!,
        data: {'email': changedEmail},
      );

      // change in username - email collection
      await tables.updateRow(
        databaseId: userDatabaseID,
        tableId: usernameTableID,
        rowId: authStateController.userName!,
        data: {'email': changedEmail},
      );

      // Set user profile in authStateController
      await authStateController.setUserProfileData();

      return true;
    } on AppwriteException catch (e) {
      log(e.toString());
      customSnackbar(
        AppLocalizations.of(context)!.tryAgain,
        e.toString(),
        LogType.error,
      );

      SemanticsService.announce(e.toString(), TextDirection.ltr);

      return false;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> changeEmailInAuth(
    String changedEmail,
    String password,
    BuildContext context,
  ) async {
    try {
      // change in auth section
      await account.updateEmail(email: changedEmail, password: password);

      return true;
    } on AppwriteException catch (e) {
      log(e.toString());
      if (e.type == userInvalidCredentials) {
        customSnackbar(
          AppLocalizations.of(context)!.tryAgain,
          AppLocalizations.of(context)!.incorrectEmailOrPassword,
          LogType.error,
        );

        SemanticsService.announce(
          AppLocalizations.of(context)!.incorrectEmailOrPassword,
          TextDirection.ltr,
        );
      } else if (e.type == generalArgumentInvalid) {
        customSnackbar(
          AppLocalizations.of(context)!.tryAgain,
          AppLocalizations.of(context)!.passwordShort,
          LogType.error,
        );

        SemanticsService.announce(
          AppLocalizations.of(context)!.passwordShort,
          TextDirection.ltr,
        );
      }

      return false;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<void> changeEmail(BuildContext context) async {
    if (changeEmailFormKey.currentState!.validate()) {
      isLoading.value = true;

      isEmailAvailable(emailController.text).then((status) {
        if (status) {
          changeEmailInAuth(
            emailController.text,
            passwordController.text,
            context,
          ).then((status) {
            if (status) {
              changeEmailInDatabases(emailController.text, context).then((
                status,
              ) {
                isLoading.value = false;

                if (status) {
                  customSnackbar(
                    AppLocalizations.of(context)!.emailChanged,
                    AppLocalizations.of(context)!.emailChangeSuccess,
                    LogType.success,
                  );

                  SemanticsService.announce(
                    AppLocalizations.of(context)!.emailChangeSuccess,
                    TextDirection.ltr,
                  );
                } else {
                  customSnackbar(
                    AppLocalizations.of(context)!.failed,
                    AppLocalizations.of(context)!.emailChangeFailed,
                    LogType.error,
                  );

                  SemanticsService.announce(
                    AppLocalizations.of(context)!.emailChangeFailed,
                    TextDirection.ltr,
                  );
                }
              });
            } else {
              isLoading.value = false;
            }
          });
        } else {
          customSnackbar(
            AppLocalizations.of(context)!.oops,
            AppLocalizations.of(context)!.emailExists,
            LogType.error,
          );

          SemanticsService.announce(
            AppLocalizations.of(context)!.emailExists,
            TextDirection.ltr,
          );
          isLoading.value = false;
        }
      });
    }
  }
}
