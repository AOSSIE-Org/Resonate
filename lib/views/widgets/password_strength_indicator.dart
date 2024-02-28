//import required packages
import 'package:flutter/material.dart';
import 'package:resonate/utils/colors.dart';
import 'package:resonate/utils/ui_sizes.dart';

//PasswordStrengthIndicator is a StatelessWidget that defined various methods for checking password strength
//and creates a custom widget that utilizes these methods to check password's strength.
class PasswordStrengthIndicator extends StatelessWidget {
  const PasswordStrengthIndicator({
    super.key,
    required this.isPasswordSixCharacters, //check weather password is 6 char long or not
    required this.hasOneDigit, //check for the presence of digit in password
    required this.hasUpperCase, //check for the presence of an UpperCase char
    required this.passwordSixCharactersTitle, //string informing about the requirements for length of password
    required this.hasOneDigitTitle, //string informing that password should have one digit
    required this.hasUpperCaseTitle, //string informing that password should have one UpperCase char
    required this.hasLowerCase, //string informing that password should have one LowerCase char
    required this.hasLowerCaseTitle, //string informing about LowerCase nature of password
    required this.validatedChecks, //the number of checks password has passed
  });

  final bool isPasswordSixCharacters;
  final bool hasOneDigit;
  final bool hasUpperCase;
  final bool hasLowerCase;
  final String passwordSixCharactersTitle;
  final String hasOneDigitTitle;
  final String hasUpperCaseTitle;
  final String hasLowerCaseTitle;

  final int validatedChecks;
  //if all requirements are met then display "Password is strong"
  final String passStrengthVerifiedText = "Password is strong";

  @override
  Widget build(BuildContext context) {
    //construction of widget
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          //display the widgets associated with the no of validatedChecks passed
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildAnimatedStrengthContainer(0),
              SizedBox(
                width: UiSizes.size_12,
              ),
              buildAnimatedStrengthContainer(1),
              SizedBox(
                width: UiSizes.size_12,
              ),
              buildAnimatedStrengthContainer(2),
            ],
          ),
          //seperation
          SizedBox(
            height: UiSizes.height_14,
          ),
          //display the title using getTitle() which returns a string from parameters above to
          //inform user about the validity of password.
          Expanded(
            child: Text(
              getTitle(),
              style: TextStyle(
                color: getTitle() == passStrengthVerifiedText
                    ? AppColor.greenColor
                    : Colors.grey,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
        ],
      ),
    );
  }

  AnimatedContainer buildAnimatedStrengthContainer(int index) {
    Color containerColor;

    // Check if all 4 conditions are true
    if (validatedChecks == 4) {
      containerColor = AppColor.greenColor; // All checks are true, green color
    }
    // Check if 3 conditions are true
    else if (validatedChecks == 3) {
      // If index is 0 or 1, set the color to yellow, else set it to gray
      containerColor =
          index < 2 ? AppColor.yellowColor : AppColor.greyShadeColor;
    }
    // Check if 2 conditions are true
    else if (validatedChecks == 2) {
      // If index is 0 or 1, set the color to yellow, else set it to gray
      if (index == 0 || index == 1) {
        containerColor = AppColor.yellowColor;
      } else {
        containerColor = AppColor.greyShadeColor;
      }
    }
    // Check if 1 condition is true
    else if (validatedChecks == 1) {
      // If index is 0, set the color to amberRed, else set it to gray
      containerColor = index == 0 ? AppColor.redColor : AppColor.greyShadeColor;
    }
    // No conditions are true, set the color to gray
    else {
      containerColor = AppColor.greyShadeColor;
    }
    //AnimatedContainer can animate itself if any of the properties of the container changes
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: UiSizes.size_65,
      height: 5,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        //The AnimatedContainer will change the color based on the value of validatedChecks
        color: containerColor,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  //getTtile is a function that returns a string defined as parameters of PasswordStrengthIndicator
  //based on the bool variables which are also defined as parameters of PasswordStrengthIndicator
  String getTitle() {
    if (!isPasswordSixCharacters) {
      return passwordSixCharactersTitle;
    } else if (!hasOneDigit) {
      return hasOneDigitTitle;
    } else if (!hasUpperCase) {
      return hasUpperCaseTitle;
    } else if (!hasLowerCase) {
      return hasLowerCaseTitle;
    } else {
      return passStrengthVerifiedText;
    }
  }
}
