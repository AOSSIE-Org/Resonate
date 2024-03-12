import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/utils/ui_sizes.dart';
import '../utils/enums/themes_enum.dart';
import 'theme_controller.dart';

Widget chooseThemeBottomSheet(
    BuildContext context, Function(String) onChangedCallback) {
  final themeController = Get.find<ThemeController>();
  var selectedThemeValue = themeController.loadTheme();

  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(
        height: 30,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Text(
          'Choose theme',
          style:
              TextStyle(fontSize: UiSizes.size_16, fontWeight: FontWeight.w500),
        ),
      ),
      RadioListTile<String>(
        value: ThemeValues.systemDefault.name,
        title: const Text('System default'),
        groupValue: selectedThemeValue,
        activeColor: Colors.amber,
        onChanged: (value) {
          themeController.changeThemeMode(ThemeMode.system);
          themeController.saveTheme(ThemeValues.systemDefault);
          selectedThemeValue = value!;
          Navigator.pop(context);
          onChangedCallback(value);
        },
      ),
      RadioListTile<String>(
        value: ThemeValues.light.name,
        title: const Text('Light'),
        groupValue: selectedThemeValue,
        activeColor: Colors.amber,
        onChanged: (value) {
          themeController.changeThemeMode(ThemeMode.light);
          themeController.saveTheme(ThemeValues.light);
          selectedThemeValue = value!;
          Navigator.pop(context);
          onChangedCallback(value);
        },
      ),
      RadioListTile<String>(
        value: ThemeValues.dark.name,
        title: const Text('Dark'),
        groupValue: selectedThemeValue,
        activeColor: Colors.amber,
        onChanged: (value) {
          themeController.changeThemeMode(ThemeMode.dark);
          themeController.saveTheme(ThemeValues.dark);

          selectedThemeValue = value!;
          Navigator.pop(context);
          onChangedCallback(value);
        },
      ),
      const SizedBox(
        height: 20,
      )
    ],
  );
}
