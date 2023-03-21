import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/modules/profile/profile_controller.dart';
import 'package:resonate/routes/app_routes.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({final Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
        builder: (controller) => Scaffold(
          appBar: AppBar(title: const Text("Profile")),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 4),
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(controller.userProfile?.pictureUrl.toString() ?? ''),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text('Name: ${controller.userProfile?.name}'),
                const SizedBox(height: 48),
                ElevatedButton(
                  onPressed: () {
                    Get.offNamed(AppRoutes.login);
                  },
                  child: const Text('Logout'),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
