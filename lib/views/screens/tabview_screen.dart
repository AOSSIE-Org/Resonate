import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/controllers/create_room_controller.dart';
import 'package:resonate/controllers/tabview_controller.dart';
import 'package:resonate/views/screens/home_screen.dart';
import 'package:resonate/views/screens/profile_screen.dart';

import '../../utils/colors.dart';
import 'create_room_screen.dart';

class TabViewScreen extends StatelessWidget {
  TabViewController controller =
      Get.put<TabViewController>(TabViewController());
  AuthStateContoller authStateController =
      Get.put<AuthStateContoller>(AuthStateContoller());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              "Resonate",
              style: TextStyle(color: Colors.amber, fontSize: 26),
            ),
            centerTitle: false,
            elevation: 10,
            backgroundColor: Color.fromRGBO(17, 17, 20, 1),
            actions: [
              IconButton(
                  onPressed: () async {
                    await authStateController.logout();
                  },
                  icon: Icon(
                    Icons.exit_to_app_rounded,
                    color: Colors.amber,
                  ))
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              if (controller.getIndex() == 2) {
                await Get.find<CreateRoomController>().createRoom();
              } else {
                Get.delete<CreateRoomController>();
                controller.setIndex(2);
              }
            },
            backgroundColor: AppColor.yellowColor,
            child:
                (controller.getIndex() == 2) ? Text("Start") : Icon(Icons.add),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: AnimatedBottomNavigationBar(
            backgroundColor: Colors.transparent,
            activeColor: Colors.amber,
            inactiveColor: Colors.amber.withOpacity(0.5),
            splashColor: Colors.black,
            shadow: Shadow(color: Color.fromRGBO(17, 17, 20, 1)),
            iconSize: 30,
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
