import 'package:flutter/material.dart';

class ThemeModel {
  final String name;
  final Color primaryColor;
  final Color onPrimaryColor;
  final Color backgroundColor;

  const ThemeModel({
    required this.name,
    required this.primaryColor,
    required this.onPrimaryColor,
    required this.backgroundColor,
  });

  factory ThemeModel.fromMap(Map<String, dynamic> map) {
    return ThemeModel(
      name: map["themeName"],
      primaryColor: Color(map["primaryColor"]),
      onPrimaryColor: Color(map["onPrimaryColor"]),
      backgroundColor: Color(map["backgroundColor"]),
    );
  }

  static Map<String, dynamic> toMap(ThemeModel model) {
    return {
      "themeName": model.name,
      "primaryColor": model.primaryColor.value,
      "onPrimaryColor": model.onPrimaryColor.value,
      "backgroundColor": model.backgroundColor.value,
    };
  }
}
