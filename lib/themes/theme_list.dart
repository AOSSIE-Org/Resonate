import 'package:flutter/material.dart';

import '../models/themes_model.dart';

class ThemeList {
  static const List<ThemeModel> themesList = [
    ThemeModel(
      name: "Classic",
      primaryColor: Color(0xff292C31),
      onPrimaryColor: Colors.white,
      secondaryColor: Color.fromARGB(255, 222, 224, 223),
      onSecondaryColor: Colors.black45,
      surfaceColor: Colors.white,
      onSurfaceColor: Colors.black,
      themeMode: ThemeMode.light,
    ),
    ThemeModel(
      name: "Time",
      primaryColor: Color(0xfff20073),
      onPrimaryColor: Colors.white,
      secondaryColor: Color(0xff21252f),
      onSecondaryColor: Colors.white38,
      surfaceColor: Color(0xff181b22),
      onSurfaceColor: Colors.white,
      themeMode: ThemeMode.dark,
    ),
    ThemeModel(
      name: "Vintage",
      primaryColor: Color(0xff503C3C),
      onPrimaryColor: Colors.white,
      secondaryColor: Color.fromARGB(255, 226, 224, 224),
      onSecondaryColor: Colors.black45,
      surfaceColor: Colors.white,
      onSurfaceColor: Colors.black,
      themeMode: ThemeMode.light,
    ),
    ThemeModel(
      name: "Amber",
      primaryColor: Colors.amber,
      onPrimaryColor: Colors.black,
      secondaryColor: Color(0xff21252f),
      onSecondaryColor: Colors.white38,
      surfaceColor: Color(0xff181b22),
      onSurfaceColor: Colors.white,
      themeMode: ThemeMode.dark,
    ),
    ThemeModel(
      name: "Forest",
      primaryColor: Color(0xff183D3D),
      onPrimaryColor: Colors.white,
      secondaryColor: Color.fromARGB(255, 217, 222, 218),
      onSecondaryColor: Colors.black45,
      surfaceColor: Colors.white,
      onSurfaceColor: Colors.black,
      themeMode: ThemeMode.light,
    ),
    ThemeModel(
      name: "Cream",
      primaryColor: Color(0xffF6B17A),
      onPrimaryColor: Colors.black,
      secondaryColor: Color(0xff424769),
      onSecondaryColor: Colors.white38,
      surfaceColor: Color(0xff2D3250),
      onSurfaceColor: Colors.white,
      themeMode: ThemeMode.dark,
    ),
  ];

  static ThemeModel getThemeModel(String themeName) {
    for (var themeModel in themesList) {
      if (themeModel.name.toLowerCase() == themeName) {
        return themeModel;
      }
    }

    // Return Classic Theme
    return themesList.first;
  }
}
