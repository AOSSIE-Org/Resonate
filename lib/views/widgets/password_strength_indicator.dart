import 'package:flutter/material.dart';
import 'package:resonate/utils/colors.dart';
import 'package:resonate/utils/ui_sizes.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  PasswordStrengthIndicator({
    super.key,
    required this.isPasswordSixCharacters,
    required this.hasOneDigit,
    required this.hasUpperCase,
    required this.passwordSixCharactersTitle,
    required this.hasOneDigitTitle,
    required this.hasUpperCaseTitle,
    required this.hasLowerCase,
    required this.hasLowerCaseTitle,
  });

  final bool isPasswordSixCharacters;
  final bool hasOneDigit;
  final bool hasUpperCase;
  final bool hasLowerCase;
  final String passwordSixCharactersTitle;
  final String hasOneDigitTitle;
  final String hasUpperCaseTitle;
  final String hasLowerCaseTitle;

  String passStrengthVerifiedText = "Password is strong";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              buildAnimatedStrengthContainer(isPasswordSixCharacters),
              SizedBox(
                width: UiSizes.size_12,
              ),
              buildAnimatedStrengthContainer(hasOneDigit),
              SizedBox(
                width: UiSizes.size_12,
              ),
              buildAnimatedStrengthContainer(hasUpperCase && hasLowerCase),
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

  AnimatedContainer buildAnimatedStrengthContainer(bool isCheck) {
    Color containerColor = Colors.grey.shade400; // Default color

    if (isCheck) {
      if (isPasswordSixCharacters && hasOneDigit) {
        if (hasUpperCase && hasLowerCase) {
          containerColor =
              AppColor.greenColor; // All checks are true, green color
        } else {
          containerColor =
              AppColor.yellowColor; // Two checks are true, yellow color
        }
      } else {
        containerColor =
            AppColor.amberRedColor; // One check is true, amberRed color
      }
    }

    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 500,
      ),
      width: UiSizes.size_65,
      height: 5,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: containerColor,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

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
