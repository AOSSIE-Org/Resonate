import 'package:flutter/material.dart';
import 'package:resonate/models/themes_model.dart';

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
      final double size = 10;
      return Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: (isBorder && isSelected)
              ? Border.all(color: theme.primaryColor, width: 0.5)
              : null,
        ),
      );
    }

    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(themeName, style: TextStyle(fontSize: 18)),
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            colorDots(theme.primaryColor),
            colorDots(theme.secondaryColor, isBorder: true),
            colorDots(theme.onPrimaryColor),
          ],
        ),
      ],
    );
  }
}
