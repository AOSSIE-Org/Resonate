import 'package:flutter/material.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/colors.dart';
import 'package:resonate/utils/ui_sizes.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  const PasswordStrengthIndicator({
    super.key,
    required this.isPasswordEightCharacters,
    required this.hasOneDigit,
    required this.hasUpperCase,
    required this.passwordSixCharactersTitle,
    required this.hasOneDigitTitle,
    required this.hasUpperCaseTitle,
    required this.hasLowerCase,
    required this.hasLowerCaseTitle,
    required this.validatedChecks,
    required this.hasOneSymbol,
    required this.hasOneSymbolTitle,
    required this.passStrengthVerifiedText,
  });

  final bool isPasswordEightCharacters;
  final bool hasOneDigit;
  final bool hasUpperCase;
  final bool hasLowerCase;
  final bool hasOneSymbol;
  final String passwordSixCharactersTitle;
  final String hasOneDigitTitle;
  final String hasUpperCaseTitle;
  final String hasLowerCaseTitle;
  final String hasOneSymbolTitle;

  final int validatedChecks;

  final String passStrengthVerifiedText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
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
              SizedBox(
                width: UiSizes.size_12,
              ),
              buildAnimatedStrengthContainer(3),
            ],
          ),
          SizedBox(
            height: UiSizes.height_14,
          ),
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

    // Check if all 5 conditions are true
    if (validatedChecks == 5) {
      containerColor = AppColor.greenColor; // All checks are true, green color
    }

    // Check if 4 conditions are true
    else if (validatedChecks == 4) {
      containerColor =
          index < 3 ? AppColor.yellowColor : AppColor.greyShadeColor;
    }

    // Check if 3 conditions are true
    else if (validatedChecks == 3) {
      // If index is 0 or 1, set the color to yellow, else set it to gray
      containerColor =
          index < 2 ? AppColor.orangeColor : AppColor.greyShadeColor;
    }
    // Check if 2 conditions are true
    else if (validatedChecks == 2) {
      // If index is 0 or 1, set the color to yellow, else set it to gray
      if (index == 0 || index == 1) {
        containerColor = AppColor.orangeColor;
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

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: UiSizes.size_56,
      height: 5,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: containerColor,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  String getTitle() {
    if (!isPasswordEightCharacters) {
      return passwordSixCharactersTitle;
    } else if (!hasOneDigit) {
      return hasOneDigitTitle;
    } else if (!hasUpperCase) {
      return hasUpperCaseTitle;
    } else if (!hasLowerCase) {
      return hasLowerCaseTitle;
    } else if (!hasOneSymbol) {
      return hasOneSymbolTitle;
    } else {
      return passStrengthVerifiedText;
    }
  }
}
