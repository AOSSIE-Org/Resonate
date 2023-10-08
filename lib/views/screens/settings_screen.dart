import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:resonate/themes/theme_controller.dart';

import '../../themes/choose_theme_bottom_sheet.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final themeController = Get.find<ThemeController>();

  late String subText;

  @override
  Widget build(BuildContext context) {
    subText = themeController.loadTheme();

    if (subText == 'systemDefault') {
      subText = 'System Default';
    } else if (subText == 'light') {
      subText = 'Light';
    } else {
      subText = 'Dark';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
        ),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 20, bottom: 10, left: 15),
            child: Text('General settings'),
          ),
          ListTile(
            leading: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(FontAwesomeIcons.circleHalfStroke),
              ],
            ),
            title: const Text('Theme'),
            subtitle: Text(subText),
            onTap: () {
              showModalBottomSheet(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                context: context,
                builder: (context) =>
                    chooseThemeBottomSheet(context, (_) => setState(() {})),
              );
            },
          )
        ],
      ),
    );
  }
}
