import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/new_theme_screen_controller.dart';
import 'package:resonate/models/themes_model.dart';
import 'package:resonate/utils/theme_list.dart';

class ThemeScreen extends StatelessWidget {
  ThemeScreen({super.key});

  static const List<ThemeModel> list = ThemeList.themesList;
  final newThemeController = Get.put(NewThemeController());




  @override
  Widget build(BuildContext context) {

    print("Theme: ${newThemeController.themeModel.value.name}");







    return Scaffold(
      appBar: AppBar(
        title: const Text("Themes"),
      ),
      body: Obx(
        ()=> Container(
            child: (newThemeController.themeModel.value.name == 'jhgfksfg') ? const Text("hehe"): ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    newThemeController.setTheme(
                      ThemeModel(
                        name: list[index].name,
                        primaryColor: list[index].primaryColor,
                        onPrimaryColor: list[index].onPrimaryColor,
                        backgroundColor: list[index].backgroundColor,
                      ),
                    );
                  },
                  selected: (newThemeController.themeModel.value.name == list[index].name),
                  selectedColor: newThemeController.themeModel.value.onPrimaryColor,
                  selectedTileColor: newThemeController.themeModel.value.primaryColor,
                  title: Text(list[index].name),
                  trailing: Container(
                    width: 80,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: list[index].backgroundColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: list[index].primaryColor,
                          ),
                          width: 15,
                          height: 15,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: list[index].onPrimaryColor,
                          ),
                          width: 15,
                          height: 15,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.red,
                          ),
                          width: 15,
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ),
      ),

    );
  }
}
