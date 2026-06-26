import 'package:flutter/material.dart';

class ThemeModel {
  final String name;
  final Color primaryColor;
  final Color onPrimaryColor;
  final Color secondaryColor;
  final Color onSecondaryColor;
  final Color surfaceColor;
  final Color onSurfaceColor;
  final ThemeMode themeMode;

  const ThemeModel({
    required this.name,
    required this.primaryColor,
    required this.onPrimaryColor,
    required this.secondaryColor,
    required this.onSecondaryColor,
    required this.surfaceColor,
    required this.onSurfaceColor,
    required this.themeMode,
  });
}
