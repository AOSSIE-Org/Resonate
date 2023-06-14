import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:resonate/controllers/tabview_controller.dart';
import 'package:resonate/views/screens/home_screen.dart';
import 'package:resonate/views/screens/profile_screen.dart';

import '../../controllers/profile_controller.dart';
import '../../utils/colors.dart';
import 'create_room_screen.dart';

class TabViewScreen extends StatelessWidget {
  TabViewController controller = Get.find<TabViewController>();
  ProfileController profileController =
      Get.put<ProfileController>(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            title: Text(
              "Resonate",
              style: TextStyle(color: Colors.black, fontSize: 26),
            ),
            centerTitle: false,
            backgroundColor: Colors.amber,
            actions: [
              IconButton(
                  onPressed: () {
                    profileController.logout();
                  },
                  icon: Icon(
                    Icons.exit_to_app_rounded,
                    color: Colors.black87,
                  ))
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              controller.setIndex(2);
            },
            backgroundColor: AppColor.yellowColor,
            child: (controller.getIndex()==2) ? Text("Start") : Icon(Icons.add),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: AnimatedBottomNavigationBar(
            backgroundColor: Colors.amber,
            activeColor: Colors.black,
            inactiveColor: Colors.black54,
            splashColor: Colors.black,
            icons: [
              Icons.home_outlined,
              Icons.person_outline,
            ],
            activeIndex: controller.getIndex(),
            gapLocation: GapLocation.center,
            notchSmoothness: NotchSmoothness.defaultEdge,
            onTap: (index) => controller.setIndex(index),
          ),
          //TODO Connect all main screens to the tab view
          body: (controller.getIndex() == 0)
              ? HomeScreen()
              : (controller.getIndex() == 1)
                  ? ProfileScreen()
                  : CreateRoomScreen(),
        ));
  }
}
