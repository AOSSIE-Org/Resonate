import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../utils/enums/themes_enum.dart';

class ThemeController extends GetxController {
  final _box = GetStorage();
  final _key = 'themeValue';

  ThemeMode get theme {
    String themeVal = loadTheme();

    if (themeVal == ThemeValues.systemDefault.name) {
      return ThemeMode.system;
    } else if (themeVal == ThemeValues.light.name) {
      return ThemeMode.light;
    } else {
      return ThemeMode.dark;
    }
  }

  Rx<Color> primaryColor = Colors.amber.obs;

  void changePrimaryColor(Color newColor) {
    primaryColor.value = newColor;
  }

  LinearGradient createDynamicGradient() {
    return LinearGradient(
      colors: [
        primaryColor.value,
        primaryColor.value.withOpacity(0.6),
      ],
    );
  }

  String loadTheme() => _box.read(_key) ?? ThemeValues.systemDefault.name;
  void changeThemeMode(ThemeMode themeMode) => Get.changeThemeMode(themeMode);
  void saveTheme(ThemeValues themeValues) => _box.write(_key, themeValues.name);
}
