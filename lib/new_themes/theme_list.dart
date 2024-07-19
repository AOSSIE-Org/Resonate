import 'package:flutter/material.dart';

import '../models/themes_model.dart';

class ThemeList {
  static const List<ThemeModel> themesList = [
    ThemeModel(
      name: "Classic",
      primaryColor: Color(0xff292C31),
      onPrimaryColor: Colors.white,
      secondaryColor: Color(0xffEDEFEE),
      onSecondaryColor: Colors.black45,
      surfaceColor: Color(0xffEDEFEE),
      onSurfaceColor: Colors.black,
      backgroundColor: Colors.white,
      themeMode: ThemeMode.light,
    ),
    ThemeModel(
      name: "Time",
      primaryColor: Color(0xfff20073),
      onPrimaryColor: Colors.white,
      secondaryColor: Color(0xff21252f),
      onSecondaryColor: Colors.white38,
      surfaceColor: Color(0xff21252f),
      onSurfaceColor: Colors.white,
      backgroundColor: Color(0xff181b22),
      themeMode: ThemeMode.dark,
    ),
    ThemeModel(
      name: "Vintage",
      primaryColor: Color(0xff503C3C),
      onPrimaryColor: Colors.white,
      secondaryColor: Color(0xffF3F0F0),
      onSecondaryColor: Colors.black45,
      surfaceColor: Color(0xffEDEFEE),
      onSurfaceColor: Colors.black,
      backgroundColor: Colors.white,
      themeMode: ThemeMode.light,
    ),
    ThemeModel(
      name: "Amber",
      primaryColor: Colors.amber,
      onPrimaryColor: Colors.black,
      secondaryColor: Color(0xff21252f),
      onSecondaryColor: Colors.white38,
      surfaceColor: Color(0xff21252f),
      onSurfaceColor: Colors.white,
      backgroundColor: Color(0xff181b22),
      themeMode: ThemeMode.dark,
    ),
    ThemeModel(
      name: "Forest",
      primaryColor: Color(0xff183D3D),
      onPrimaryColor: Colors.white,
      secondaryColor: Color(0xffedefed),
      onSecondaryColor: Colors.black45,
      surfaceColor: Color(0xffEDEFEE),
      onSurfaceColor: Colors.black,
      backgroundColor: Colors.white,
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
      backgroundColor: Color(0xff2D3250),
      themeMode: ThemeMode.dark,
    ),

  ];

  static ThemeModel getThemeModel(String themeName) {
    for (var themeModel in themesList) {
      if (themeModel.name.toLowerCase() == themeName) {
        return themeModel;
      }
    }

    return const ThemeModel(
      name: "Classic",
      primaryColor: Color(0xff292C31),
      onPrimaryColor: Colors.white,
      secondaryColor: Color(0xffEDEFEE),
      onSecondaryColor: Colors.black45,
      surfaceColor: Color(0xffEDEFEE),
      onSurfaceColor: Colors.black,
      backgroundColor: Colors.white,
      themeMode: ThemeMode.light,
    );
  }
}
