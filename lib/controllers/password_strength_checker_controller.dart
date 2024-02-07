import 'package:get/get.dart';

class PasswordStrengthCheckerController extends GetxController {
  RxBool isVisible = false.obs;
  RxBool isVisibleAtLogin = false.obs;
  RxBool isVisibleAtSignUp = false.obs;
  RxBool isPasswordSixCharacters = false.obs;
  RxBool hasOneDigit = false.obs;
  RxBool hasUpperCase = false.obs;
  RxBool hasLowerCase = false.obs;

  RxInt get validatedChecks => RxInt([
        isPasswordSixCharacters,
        hasOneDigit,
        hasUpperCase,
        hasLowerCase
      ].where((check) => check.value).length);

  void passwordValidator(String pass, String page) {
    isVisible.value = false;
    if (pass.isNotEmpty) {
      if (page == 'login') {
        isVisibleAtLogin.value = true;
      } else {
        isVisibleAtSignUp.value = true;
      }
      isVisible.value = true;
    } else {
      isVisibleAtLogin.value = false;
      isVisibleAtSignUp.value = false;
    }
    isPasswordSixCharacters.value = false;
    if (pass.length >= 6) isPasswordSixCharacters.value = true;

    hasOneDigit.value = false;
    if (AppRegExp.containsNumericRegex.hasMatch(pass)) {
      hasOneDigit.value = true;
    }
    hasUpperCase.value = false;
    if (AppRegExp.containsUpperCaseRegex.hasMatch(pass)) {
      hasUpperCase.value = true;
    }
    hasLowerCase.value = false;
    if (AppRegExp.containsLowerCaseRegex.hasMatch(pass)) {
      hasLowerCase.value = true;
    }
  }
}

class AppRegExp {
  AppRegExp._();

  static final containsNumericRegex = RegExp(r'[0-9]');
  static final containsUpperCaseRegex = RegExp(r'[A-Z]');
  static final containsLowerCaseRegex = RegExp(r'[a-z]');
}
