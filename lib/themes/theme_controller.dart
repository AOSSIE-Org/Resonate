//import required packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../utils/enums/themes_enum.dart';

//Create ThemeController extending GetXController
//GetXController is provided by get state management.
//GetXController allows the business logic to be seperated from UI.
//This allows ThemeController to be used anywere in the app.
//We have used Get.put(ThemeController()) in main.dart to create an instance of ThemeController inside MyApp.
class ThemeController extends GetxController {
  //create an instance of GetStorage provided by get_storage package.
  final _box = GetStorage();
  //This value is used to read 'themeValue' stored in _box using _box.read(_key) below.
  final _key = 'themeValue';
  //ThemeMode defines the themes(light or dark) used by app.
  ThemeMode get theme {
    //loadTheme function is defined below.
    //stores the string value returned by loadTheme.
    String themeVal = loadTheme();
    //return ThemeMode based on the value stored in themeVal.
    //checks weather themeVal equals the Default System Theme.
    if (themeVal == ThemeValues.systemDefault.name) {
      return ThemeMode.system;
    }
    //checks weather themeVal equals the Light Theme.
    else if (themeVal == ThemeValues.light.name) {
      return ThemeMode.light;
    }
    //If both values are unequal dark theme is returned.
    else {
      return ThemeMode.dark;
    }
  }

  //loadTheme is used to read the ThemeValue stored in _box which is an instance of GetStorage.
  //loadTheme returns a string containing System theme.
  String loadTheme() => _box.read(_key) ?? ThemeValues.systemDefault.name;
  //changeThemeMode is recursive function used to change theme of app based on themeMode.
  void changeThemeMode(ThemeMode themeMode) => Get.changeThemeMode(themeMode);
  //saveTheme is recursive function used to save themeValues using _box.write.
  void saveTheme(ThemeValues themeValues) => _box.write(_key, themeValues.name);
}
