import 'dart:async';
import 'dart:developer';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/rendering.dart';
import 'package:resonate/services/appwrite_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/views/widgets/snackbar.dart';

import 'package:resonate/l10n/app_localizations.dart';

class AuthenticationController extends GetxController {
  var isPasswordFieldVisible = false.obs;
  var isConfirmPasswordFieldVisible = false.obs;
  var isLoading = false.obs;
  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");
  TextEditingController confirmPasswordController = TextEditingController(
    text: "",
  );
  AuthStateController authStateController = Get.find<AuthStateController>();

  late GlobalKey<FormState> loginFormKey;
  late GlobalKey<FormState> registrationFormKey;

  Future<void> login(BuildContext context) async {
    try {
      isLoading.value = true;
      await authStateController.login(
        emailController.text,
        passwordController.text,
      );
      emailController.clear();
      passwordController.clear();
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
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> signup(BuildContext context) async {
    try {
      isLoading.value = true;
      await authStateController.signup(
        emailController.text,
        passwordController.text,
      );
      return true;
    } catch (e) {
      log(e.toString());
      customSnackbar(
        AppLocalizations.of(context)!.oops,
        e.toString(),
        LogType.error,
      );
      SemanticsService.announce(e.toString(), TextDirection.ltr);

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      await authStateController.loginWithGoogle();
    } catch (error) {
      log(error.toString());
    }
  }

  Future<void> loginWithGithub() async {
    try {
      await authStateController.loginWithGithub();
    } catch (error) {
      log(error.toString());
    }
  }

  Future<void> resetPassword(String email, BuildContext context) async {
    try {
      if (!email.isValidEmail()) {
        return;
      }

      var account = AppwriteService.getAccount();
      await account.createRecovery(
        email: email,
        url:
            'https://localhost/reset-password', // Replace with actual reset password URL
      );
      customSnackbar(
        AppLocalizations.of(context)!.success,
        AppLocalizations.of(context)!.passwordResetSent,
        LogType.success,
      );

      SemanticsService.announce(
        AppLocalizations.of(context)!.passwordResetSent,
        TextDirection.ltr,
      );
      //Get.toNamed(AppRoutes.resetPassword); To navigate to resetPassword screen on clicking the link
    } on AppwriteException catch (e) {
      customSnackbar(
        AppLocalizations.of(context)!.error,
        e.message.toString(),
        LogType.error,
      );

      SemanticsService.announce(e.message.toString(), TextDirection.ltr);
    }
  }

  Future<bool> confirmPasswordReset({
    required String userId,
    required String secret,
    required String newPassword,
    required BuildContext context,
  }) async {
    try {
      isLoading.value = true;
      var account = AppwriteService.getAccount();
      await account.updateRecovery(
        userId: userId,
        secret: secret,
        password: newPassword,
      );

      if (!context.mounted) return true;
      final l10n = AppLocalizations.of(context)!;

      customSnackbar(l10n.success, l10n.passwordResetSuccess, LogType.success);

      SemanticsService.announce(l10n.passwordResetSuccess, TextDirection.ltr);

      Get.offNamed(AppRoutes.loginScreen);
      return true;
    } on AppwriteException catch (e) {
      if (!context.mounted) return false;
      log(e.message ?? 'AppwriteException in confirmPasswordReset');
      final errorTitle = AppLocalizations.of(context)!.error;
      final errorMessage = (e.message != null && e.message!.isNotEmpty)
          ? e.message!
          : errorTitle;
      customSnackbar(errorTitle, errorMessage, LogType.error);

      SemanticsService.announce(errorMessage, TextDirection.ltr);
      return false;
    } catch (e) {
      if (!context.mounted) return false;
      log(e.toString());
      final errorTitle = AppLocalizations.of(context)!.error;
      customSnackbar(errorTitle, e.toString(), LogType.error);

      SemanticsService.announce(e.toString(), TextDirection.ltr);
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}

extension Validator on String {
  bool isValidEmail() {
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(this);
  }

  bool isValidPassword() {
    return RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$',
    ).hasMatch(this);
  }

  bool isSamePassword(String password) {
    return this == password;
  }
}
