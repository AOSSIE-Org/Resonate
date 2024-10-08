import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:resonate/utils/ui_sizes.dart';

class UserAccountScreen extends StatelessWidget {
  const UserAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: UiSizes.height_10),
        children: [
          ListTile(
            textColor: Colors.redAccent,
            iconColor: Colors.redAccent,
            title: const Text(
              "Delete account",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_rounded),
            onTap: () {
              Get.toNamed(AppRoutes.deleteAccount);
            },
          ),
        ],
      ),
    );
  }
}
