import 'package:flutter/material.dart';
import 'package:resonate/features/auth/model/password_strength.dart';
import 'package:resonate/utils/colors.dart';
import 'package:resonate/utils/ui_sizes.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  const PasswordStrengthIndicator({
    super.key,
    required this.strength,
    required this.minLengthLabel,
    required this.digitLabel,
    required this.uppercaseLabel,
    required this.lowercaseLabel,
    required this.symbolLabel,
    required this.verifiedLabel,
  });

  final PasswordStrength strength;
  final String minLengthLabel;
  final String digitLabel;
  final String uppercaseLabel;
  final String lowercaseLabel;
  final String symbolLabel;
  final String verifiedLabel;

  @override
  Widget build(BuildContext context) {
    final score = strength.score;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (i) {
              return Padding(
                padding: i == 0
                    ? EdgeInsets.zero
                    : EdgeInsets.only(left: UiSizes.size_12),
                child: _bar(_colorFor(score, i)),
              );
            }),
          ),
          SizedBox(height: UiSizes.height_14),
          Expanded(
            child: Text(
              _label,
              style: TextStyle(
                color: _label == verifiedLabel
                    ? AppColor.greenColor
                    : Colors.grey,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String get _label {
    if (!strength.hasMinLength) return minLengthLabel;
    if (!strength.hasDigit) return digitLabel;
    if (!strength.hasUppercase) return uppercaseLabel;
    if (!strength.hasLowercase) return lowercaseLabel;
    if (!strength.hasSymbol) return symbolLabel;
    return verifiedLabel;
  }

  Color _colorFor(int score, int barIndex) {
    return switch (score) {
      5 => AppColor.greenColor,
      4 => barIndex < 3 ? AppColor.yellowColor : AppColor.greyShadeColor,
      3 => barIndex < 2 ? AppColor.orangeColor : AppColor.greyShadeColor,
      2 => barIndex < 2 ? AppColor.orangeColor : AppColor.greyShadeColor,
      1 => barIndex == 0 ? AppColor.redColor : AppColor.greyShadeColor,
      _ => AppColor.greyShadeColor,
    };
  }

  Widget _bar(Color color) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: UiSizes.size_56,
      height: 5,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
