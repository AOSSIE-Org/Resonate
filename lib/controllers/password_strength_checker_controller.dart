import 'package:get/get.dart';

class PasswordStrengthCheckerController extends GetxController {
  RxBool isVisible = false.obs;
  RxBool isPasswordEightCharacters = false.obs;
  RxBool hasOneDigit = false.obs;
  RxBool hasUpperCase = false.obs;
  RxBool hasLowerCase = false.obs;
  RxBool hasOneSymbol = false.obs;

  RxInt get validatedChecks => RxInt([
        isPasswordEightCharacters,
        hasOneDigit,
        hasUpperCase,
        hasLowerCase,
        hasOneSymbol,
      ].where((check) => check.value).length);

  void passwordValidator(String pass) {
    isVisible.value = false;
    if (pass.isNotEmpty) {
      isVisible.value = true;
    }
    isPasswordEightCharacters.value = false;
    if (pass.length >= 8) isPasswordEightCharacters.value = true;

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
    hasOneSymbol.value = false;
    if(AppRegExp.containsOneSymbolRegex.hasMatch(pass)){
      hasOneSymbol.value = true;
    }
  }
}

class AppRegExp {
  AppRegExp._();

  static final containsNumericRegex = RegExp(r'[0-9]');
  static final containsUpperCaseRegex = RegExp(r'[A-Z]');
  static final containsLowerCaseRegex = RegExp(r'[a-z]');
  static final containsOneSymbolRegex = RegExp(r'[^\w\s]');
}

