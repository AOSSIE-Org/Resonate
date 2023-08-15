import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/controllers/create_room_controller.dart';
import 'package:resonate/controllers/tabview_controller.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/views/screens/discussions_screen.dart';
import 'package:resonate/views/screens/home_screen.dart';
import 'package:resonate/views/widgets/profile_avatar.dart';

import '../../controllers/email_verify_controller.dart';
import '../../utils/colors.dart';
import 'create_room_screen.dart';

class TabViewScreen extends StatelessWidget {
  final TabViewController controller =
      Get.put<TabViewController>(TabViewController());
  final AuthStateController authStateController =
      Get.put<AuthStateController>(AuthStateController());
  final EmailVerifyController emailverifycontroller =
      Get.find<EmailVerifyController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            toolbarHeight: UiSizes.size_56,
            automaticallyImplyLeading: false,
            title: Text(
              "Resonate",
              style: TextStyle(color: Colors.amber, fontSize: UiSizes.size_26),
            ),
            centerTitle: false,
            elevation: 10,
            backgroundColor: const Color.fromRGBO(17, 17, 20, 1),
            actions: [
              profileAvatar(context),
            ],
          ),
          floatingActionButton: SizedBox(
            height: UiSizes.height_56,
            width: UiSizes.width_56,
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
                      style: TextStyle(fontSize: UiSizes.size_14),
                    )
                  : Icon(
                      Icons.add,
                      size: UiSizes.size_24,
                    ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: AnimatedBottomNavigationBar(
            height: UiSizes.size_56,
            backgroundColor: Colors.transparent,
            activeColor: Colors.amber,
            inactiveColor: Colors.amber.withOpacity(0.5),
            splashColor: Colors.black,
            shadow: const Shadow(color: Color.fromRGBO(17, 17, 20, 1)),
            iconSize: UiSizes.size_30,
            icons: const [
              Icons.home_outlined,
              // Icons.person_outline, // move to the appbar and replaced with discussions icon
              Icons.chat_rounded
            ],
            notchMargin: UiSizes.size_8,
            activeIndex: controller.getIndex(),
            gapLocation: GapLocation.center,
            notchSmoothness: NotchSmoothness.defaultEdge,
            onTap: (index) => controller.setIndex(index),
          ),
          body: (controller.getIndex() == 0)
              ? HomeScreen()
              : (controller.getIndex() == 2)
                  ? CreateRoomScreen()
                  : const DiscussionScreen(),
        ));
  }
}
