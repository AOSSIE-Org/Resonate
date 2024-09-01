import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:resonate/utils/ui_sizes.dart';

import '../../controllers/auth_state_controller.dart';

class NewSettingsScreen extends StatelessWidget {
  NewSettingsScreen({super.key});

  final authStateController =
      Get.put<AuthStateController>(AuthStateController());

  final double padding = UiSizes.width_20;

  Widget customTile({
    required String str,
    required Callback func,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: padding,
      ),
      title: Text(str),
      trailing: const Icon(Icons.arrow_forward_rounded),
      onTap: func,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget customDivider() {
      return Divider(
        height: UiSizes.height_30,
        thickness: 10,
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.black.withOpacity(0.04)
            : Colors.white.withOpacity(0.04),
      );
    }

    Widget titleText(String str) {
      return Padding(
        padding: EdgeInsets.only(
          left: padding,
          top: UiSizes.height_16,
          bottom: UiSizes.height_10,
        ),
        child: Text(str,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black54
                  : Colors.white54,
              fontWeight: FontWeight.bold,
            )),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        children: [
          titleText("Account settings"),
          customTile(
            str: "Account",
            func: () {
              Get.toNamed(AppRoutes.userAccountScreen);
            },
          ),
          customDivider(),
          titleText("App settings"),
          customTile(
            str: "Themes",
            func: () {
              Get.toNamed(AppRoutes.themeScreen);
            },
          ),
          customTile(
            str: "About",
            func: () {
              Get.toNamed(AppRoutes.aboutApp);
            },
          ),
          customDivider(),
          titleText("Other"),
          customTile(
            str: "Contribute",
            func: () {
              Get.toNamed(AppRoutes.contributeScreen);
            },
          ),
          customDivider(),
          ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: padding,
            ),
            textColor: Colors.redAccent,
            iconColor: Colors.redAccent,
            title: const Text(
              "Log out",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: const Icon(Icons.logout_rounded),
            onTap: () async {
              await authStateController.logout(context);
            },
          ),
        ],
      ),
    );
  }
}
