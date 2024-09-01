
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/new_themes/new_theme_screen_controller.dart';
import 'package:resonate/models/themes_model.dart';
import 'package:resonate/new_themes/theme_list.dart';

class ThemeScreen extends StatelessWidget {
  ThemeScreen({super.key});

  static const List<ThemeModel> list = ThemeList.themesList;
  final newThemeController = Get.put(NewThemeController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Themes"),
      ),
      body: Obx(
        ()=> Container(
            child: (newThemeController.currentTheme.value == 'none') ? const Text("none"): ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    newThemeController.setTheme(list[index].name.toLowerCase());
                  },
                  selected: (newThemeController.currentTheme.value == list[index].name.toLowerCase()),
                  selectedColor: list[index].onPrimaryColor,
                  selectedTileColor: list[index].primaryColor,
                  title: Text(list[index].name),
                  trailing: Container(
                    width: 50,
                    height: 30,
                    decoration: BoxDecoration(
                      border: Border.all(color: list[index].primaryColor),
                      borderRadius: BorderRadius.circular(50),
                      color: list[index].surfaceColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: list[index].primaryColor,
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
