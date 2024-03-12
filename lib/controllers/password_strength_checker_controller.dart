//import required packages
import 'package:get/get.dart';
//PasswordStrengthCheckerController is used to check the strenth of pass entered by user
class PasswordStrengthCheckerController extends GetxController {
  RxBool isVisible = false.obs; //reactive bool variable which allows user to toggle visibility of password
  RxBool isPasswordSixCharacters = false.obs; //reactive bool variable that checks weather password entered is at least 6 digits long
  RxBool hasOneDigit = false.obs; //reactive bool variable that checks weather password has a digit
  RxBool hasUpperCase = false.obs; //reactive bool variable that checks weather password has a upper case character
  RxBool hasLowerCase = false.obs; //reactive bool variable that checks weather password has a lower case chracter
 //The validatedChecks getter combines the checks into a single reactive integer value, 
 //counting the number of checks that have passed.
  RxInt get validatedChecks => RxInt([
        isPasswordSixCharacters,
        hasOneDigit,
        hasUpperCase,
        hasLowerCase
      ].where((check) => check.value).length);
  //passwordValidator method updates the state of reactive bool variables based on the String pass. 
  //It checks if the password is not empty, 
  //has at least six characters, 
  //contains at least one digit,
  //and has both uppercase and lowercase characters
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
//AppRegExp class defines regular expressions for matching numeric, uppercase, and lowercase characters,
//which are used in the passwordValidator method to validate the password
class AppRegExp {
  AppRegExp._();

  static final containsNumericRegex = RegExp(r'[0-9]');
  static final containsUpperCaseRegex = RegExp(r'[A-Z]');
  static final containsLowerCaseRegex = RegExp(r'[a-z]');
}
