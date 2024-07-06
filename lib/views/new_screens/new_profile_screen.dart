import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/views/new_widgets/new_loading_dialog.dart';

import '../../controllers/auth_state_controller.dart';
import '../../controllers/email_verify_controller.dart';
import '../../routes/app_routes.dart';
import '../../utils/ui_sizes.dart';

class NewProfileScreen extends StatelessWidget {
  const NewProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailVerifyController =
        Get.put<EmailVerifyController>(EmailVerifyController());
    final authStateController =
        Get.put<AuthStateController>(AuthStateController());

    return GetBuilder<AuthStateController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(
            vertical: UiSizes.height_20,
            horizontal: UiSizes.width_20,
          ),
          width: double.maxFinite,
          child: Column(
            children: [
              SizedBox(
                width: double.maxFinite,
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      backgroundImage:
                          NetworkImage(controller.profileImageUrl ?? ''),
                      radius: UiSizes.width_66,
                    ),
                    SizedBox(
                      width: UiSizes.width_20,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.displayName.toString(),
                            style: TextStyle(
                              fontSize: UiSizes.size_24,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            "@${controller.userName}",
                            style: TextStyle(
                              fontSize: UiSizes.size_14,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          (controller.isEmailVerified!)
                              ? const Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.verified_user_outlined,
                                        color: Colors.green,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Verified user",
                                        style: TextStyle(color: Colors.green),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              (!controller.isEmailVerified!)
                  ? Container(
                      margin: EdgeInsets.only(top: UiSizes.height_20),
                      width: double.maxFinite,
                      child: OutlinedButton(
                        onPressed: () {
                          // Display Loading Dialog
                          newLoadingDialog(context);

                          emailVerifyController.isSending.value = true;
                          emailVerifyController.sendOTP();

                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.verified_user_outlined),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Verify Email"),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(),
              SizedBox(
                height: UiSizes.height_20,
              ),
              SizedBox(
                width: double.maxFinite,
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 34,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.toNamed(AppRoutes.editProfile);
                          },
                          child: const FittedBox(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.edit),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("Edit Profile"),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: UiSizes.width_5,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 34,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.toNamed(AppRoutes.settings);
                          },
                          child: const FittedBox(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.settings),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("Settings"),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
