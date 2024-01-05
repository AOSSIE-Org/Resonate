import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:resonate/routes/app_routes.dart';
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
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: ListView(
          children: [
            const Text('General settings'),
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
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  context: context,
                  builder: (context) =>
                      chooseThemeBottomSheet(context, (_) => setState(() {})),
                );
              },
            ),
            const SizedBox(
              height: 30,
            ),
            const Text('Account settings'),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    side: const BorderSide(color: Colors.redAccent)),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.deleteAccount);
                },
                child: const Text(
                  'Delete Account',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
