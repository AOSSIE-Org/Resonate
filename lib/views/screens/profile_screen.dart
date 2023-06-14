import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/authentication_controller.dart';
import 'package:resonate/controllers/profile_controller.dart';
import 'package:resonate/routes/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({final Key? key}) : super(key: key);
  final AuthenticationController authenticationController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(title: const Text("Profile")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue, width: 4),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                            controller.user?.photoURL.toString() ?? ''),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text('Email: ${controller.user?.email}'),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () {
                  authenticationController.logout();
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
