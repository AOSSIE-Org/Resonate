import 'package:flutter/material.dart';

import '../models/themes_model.dart';

class ThemeList {
  static const List<ThemeModel> themesList = [

    ThemeModel(name: "Vintage", primaryColor: Color(0xff543310), onPrimaryColor: Color(0xffAF8F6F), backgroundColor: Color(0xffF8F4E1)),


    ThemeModel(name: "Classic Dark", primaryColor: Colors.white, onPrimaryColor: Colors.black, backgroundColor: Colors.black),
  ];
}