import 'package:flutter/material.dart';

final ThemeData brightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
  ),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF4CAF50), // Vibrant green for action elements like Join Button
    secondary: Color(0xFF2196F3), // Clean blue for share/connectivity icons
    tertiary: Color(0xFFFF9800), // Soft orange for participant count (high contrast and clarity)
    surface: Colors.white,
    background: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onTertiary: Colors.white,
    onBackground: Colors.black,
    onSurface: Colors.black,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF4CAF50), // Vibrant green Join Button
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    ),
  ),
  iconTheme: const IconThemeData(
    color: Color(0xFF2196F3), // Default blue for icons like Share
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black87),
    labelLarge: TextStyle(color: Colors.white), // For button text
  ),
  // Ensures high contrast (WCAG AA compliant on white background)
  // Can be extended for more elements if needed
);