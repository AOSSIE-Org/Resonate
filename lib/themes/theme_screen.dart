
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/themes/theme_controller.dart';
import 'package:resonate/models/themes_model.dart';
import 'package:resonate/themes/theme_list.dart';

class ThemeScreen extends StatelessWidget {
  ThemeScreen({super.key});

  static const List<ThemeModel> list = ThemeList.themesList;
  final themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Themes"),
      ),
      body: Obx(
        ()=> ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    themeController.setTheme(list[index].name.toLowerCase());
                  },
                  selected: (themeController.currentTheme.value == list[index].name.toLowerCase()),
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
      );
  }
}
