import 'package:flutter/material.dart';
import 'package:resonate/models/themes_model.dart';

class TileTrailing extends StatelessWidget {
  final ThemeModel theme;
  final bool isSelected;
  const TileTrailing({
    super.key,
    required this.theme,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    Widget nonSelectedIcon() {
      final double size = 30;
      return Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(50, 50, 93, 0.25),
              blurRadius: 27,
              spreadRadius: -5,
              offset: Offset(0, 13),
            ),
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.3),
              blurRadius: 16,
              spreadRadius: -8,
              offset: Offset(0, 8),
            ),
          ],
          shape: BoxShape.circle,
          color: Colors.white,
        ),
      );
    }

    if (isSelected) {
      return Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(38, 57, 77, 1),
              blurRadius: 30,
              spreadRadius: -10,
              offset: Offset(0, 20),
            ),
          ],
          color: theme.primaryColor,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.check, color: theme.onPrimaryColor),
      );
    }

    return nonSelectedIcon();
  }
}
