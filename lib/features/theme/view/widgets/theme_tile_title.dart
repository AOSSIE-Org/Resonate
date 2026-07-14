import 'package:flutter/material.dart';
import 'package:resonate/features/theme/model/theme_model.dart';
import 'package:resonate/utils/ui_sizes.dart';

class TileTitle extends StatelessWidget {
  final String themeName;
  final ThemeModel theme;
  final bool isSelected;

  const TileTitle({
    super.key,
    required this.themeName,
    required this.theme,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    Widget colorDots(Color color, {bool isBorder = false}) {
      final double size = UiSizes.width_10;
      return Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: (isBorder && isSelected)
              ? Border.all(color: theme.primaryColor, width: UiSizes.width_0_5)
              : null,
        ),
      );
    }

    return Column(
      spacing: UiSizes.height_8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(themeName, style: TextStyle(fontSize: UiSizes.size_18)),
        SizedBox(width: UiSizes.width_8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            colorDots(theme.primaryColor),
            SizedBox(width: UiSizes.width_8),
            colorDots(theme.secondaryColor, isBorder: true),
            SizedBox(width: UiSizes.width_8),
            colorDots(theme.onPrimaryColor),
          ],
        ),
      ],
    );
  }
}
