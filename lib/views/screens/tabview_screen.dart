import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/controllers/authentication_controller.dart';
import 'package:resonate/controllers/create_room_controller.dart';
import 'package:resonate/controllers/tabview_controller.dart';
import 'package:resonate/views/screens/home_screen.dart';
import 'package:resonate/views/screens/profile_screen.dart';

import '../../utils/colors.dart';
import 'create_room_screen.dart';

class TabViewScreen extends StatelessWidget {
  final TabViewController controller =
      Get.put<TabViewController>(TabViewController());
  final AuthStateController authStateController =
      Get.put<AuthStateController>(AuthStateController());
  final AuthenticationController authController =
      Get.put<AuthenticationController>(AuthenticationController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            toolbarHeight: (0.068 * Get.width + 0.034 * Get.height),
            automaticallyImplyLeading: false,
            title: Text(
              "Resonate",
              style: TextStyle(
                  color: Colors.amber,
                  fontSize: 0.0315 * Get.width + 0.01582 * Get.height),
            ),
            centerTitle: false,
            elevation: 10,
            backgroundColor: const Color.fromRGBO(17, 17, 20, 1),
            actions: [
              IconButton(
                  onPressed: authController.isSending.value
                      ? () {
                          Get.snackbar("Sending OTP...", "Please wait");
                        }
                      : () async {
                          await authStateController.logout();
                        },
                  icon: Icon(
                    Icons.exit_to_app_rounded,
                    color: Colors.amber,
                    size: 0.0146 * Get.height + 0.02916 * Get.width,
                  ))
            ],
          ),
          floatingActionButton: SizedBox(
            height: 0.06815 * Get.height,
            width: 0.1361 * Get.width,
            child: FloatingActionButton(
              onPressed: () async {
                print("pressed");
                if (controller.getIndex() == 2) {
                  await Get.find<CreateRoomController>().createRoom();
                } else {
                  Get.delete<CreateRoomController>();
                  controller.setIndex(2);
                }
              },
              backgroundColor: AppColor.yellowColor,
              child: (controller.getIndex() == 2)
                  ? Text(
                      "Start",
                      style: TextStyle(
                          fontSize: 0.0085 * Get.height + 0.017 * Get.width),
                    )
                  : Icon(
                      Icons.add,
                      size: 0.0146 * Get.height + 0.02916 * Get.width,
                    ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: AnimatedBottomNavigationBar(
            height: 0.034 * Get.height + 0.068 * Get.width,
            backgroundColor: Colors.transparent,
            activeColor: Colors.amber,
            inactiveColor: Colors.amber.withOpacity(0.5),
            splashColor: Colors.black,
            shadow: const Shadow(color: Color.fromRGBO(17, 17, 20, 1)),
            iconSize: 0.01825 * Get.height + 0.0364 * Get.width,
            icons: const [
              Icons.home_outlined,
              Icons.person_outline,
            ],
            notchMargin: 0.009722 * Get.width + 0.00486 * Get.height,
            activeIndex: controller.getIndex(),
            gapLocation: GapLocation.center,
            notchSmoothness: NotchSmoothness.defaultEdge,
            onTap: (index) => controller.setIndex(index),
          ),
          body: (controller.getIndex() == 0)
              ? HomeScreen()
              : (controller.getIndex() == 1)
                  ? ProfileScreen()
                  : CreateRoomScreen(),
        ));
  }
}
