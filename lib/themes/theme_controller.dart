import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../utils/enums/themes_enum.dart';

class ThemeController extends GetxController {
  final _box = GetStorage();
  final _key = 'themeValue';

  ThemeMode get theme {
    //The loadTheme() function provides the theme saved by user,
    // or else it returns systemDefaultTheme by default.
    String themeVal = loadTheme();

    if (themeVal == ThemeValues.systemDefault.name) {
      return ThemeMode.system;
    } else if (themeVal == ThemeValues.light.name) {
      return ThemeMode.light;
    } else {
      return ThemeMode.dark;
    }
  }

  /*
    - This code retrieves the currently selected theme for the application.
    - It prioritizes loading previously saved user preference,but defaults to system's default theme,
      if a preference is not found.
   */
  String loadTheme() => _box.read(_key) ?? ThemeValues.systemDefault.name;

  /*
  - This function offers a convenient way to switch between different theme 
    modes in app using GetX package
   */
  void changeThemeMode(ThemeMode themeMode) => Get.changeThemeMode(themeMode);

/*
- This function saves the user preferred theme in Database called as GetStorage() [key-value pair db].
 */
  void saveTheme(ThemeValues themeValues) => _box.write(_key, themeValues.name);
}
