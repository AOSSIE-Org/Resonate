import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/controllers/create_room_controller.dart';
import 'package:resonate/controllers/tabview_controller.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:resonate/views/screens/discussions_screen.dart';
import 'package:resonate/views/screens/home_screen.dart';
import 'package:resonate/views/widgets/profile_avatar.dart';

import '../../utils/colors.dart';
import 'create_room_screen.dart';

class TabViewScreen extends StatelessWidget {
  final TabViewController controller =
      Get.put<TabViewController>(TabViewController());
  final AuthStateController authStateController =
      Get.put<AuthStateController>(AuthStateController());

  TabViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: GestureDetector(
                onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
                child: profileAvatar(context)),
            title: const Text(
              "Resonate",
              style: TextStyle(color: Colors.amber, fontSize: 26),
            ),
            centerTitle: false,
            elevation: 10,
            backgroundColor: const Color.fromRGBO(17, 17, 20, 1),
            actions: [
              IconButton(
                  onPressed: () async {
                    await authStateController.logout();
                  },
                  icon: const Icon(
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
            child: (controller.getIndex() == 2)
                ? const Text("Start")
                : const Icon(Icons.add),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: AnimatedBottomNavigationBar(
            backgroundColor: Colors.transparent,
            activeColor: Colors.amber,
            inactiveColor: Colors.amber.withOpacity(0.5),
            splashColor: Colors.black,
            shadow: const Shadow(color: Color.fromRGBO(17, 17, 20, 1)),
            iconSize: 30,
            icons: const [
              Icons.home_outlined,
              // Icons.person_outline, // move to the appbar and replaced with discussions icon
              Icons.chat_rounded
            ],
            activeIndex: controller.getIndex(),
            gapLocation: GapLocation.center,
            notchSmoothness: NotchSmoothness.defaultEdge,
            onTap: (index) => controller.setIndex(index),
          ),
          //TODO Connect all main screens to the tab view
          body: (controller.getIndex() == 0)
              ? HomeScreen()
              : (controller.getIndex() == 2)
                  ? CreateRoomScreen()
                  : const DiscussionScreen(),
        ));
  }
}
