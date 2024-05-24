import 'package:get/get.dart';

class PasswordStrengthCheckerController extends GetxController {
  RxBool isVisible = false.obs;
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

  void passwordValidator(String pass) {
    isVisible.value = false;
    if (pass.isNotEmpty) {
      isVisible.value = true;
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
