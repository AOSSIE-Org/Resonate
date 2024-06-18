import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/themes_model.dart';

class NewThemeController extends GetxController {
  final _box = GetStorage();
  final _key = 'newTheme';

  @override
  void onInit() {
    super.onInit();

    themeModel.value = newTheme;


  }

  ThemeModel get newTheme {
    if(_box.read(_key) != null){
      return ThemeModel.fromMap(_box.read(_key));
    }else{
      return const ThemeModel(
        name: "Classic",
        primaryColor: Colors.black,
        onPrimaryColor: Colors.white,
        backgroundColor: Colors.white,
      );
    }

  }

  Rx<ThemeModel> themeModel =  const ThemeModel(
    name: "Classic",
    primaryColor: Colors.black,
    onPrimaryColor: Colors.white,
    backgroundColor: Colors.white,
  ).obs;

  void updateTheme(ThemeModel newThemeModel){
    themeModel.value = newThemeModel;
  }


  void setTheme(ThemeModel themeModel) {
    _box.write(_key, ThemeModel.toMap(themeModel));
    updateTheme(themeModel);
  }


}
