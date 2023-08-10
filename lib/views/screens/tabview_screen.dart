import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/controllers/create_room_controller.dart';
import 'package:resonate/controllers/tabview_controller.dart';
import 'package:resonate/views/screens/discussions_screen.dart';
import 'package:resonate/views/screens/home_screen.dart';
import 'package:resonate/views/widgets/profile_avatar.dart';

import '../../utils/colors.dart';
import 'create_room_screen.dart';

class TabViewScreen extends StatelessWidget {
  final TabViewController controller = Get.put<TabViewController>(TabViewController());

  AuthStateController authStateController = Get.put<AuthStateController>(AuthStateController());

  TabViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text(
              "Resonate",
              style: TextStyle(color: Colors.amber, fontSize: 26),
            ),
            centerTitle: false,
            elevation: 10,
            backgroundColor: const Color.fromRGBO(17, 17, 20, 1),
            actions: [profileAvatar(context)],
          ),
          floatingActionButton: (controller.getIndex() != 2)
              ? SpeedDial(
                  icon: Icons.add,
                  activeIcon: Icons.close,
                  backgroundColor: AppColor.yellowColor,
                  elevation: 8.0,
                  spacing: 10,
                  spaceBetweenChildren: 6,
                  animationCurve: Curves.elasticInOut,
                  children: [
                    SpeedDialChild(
                      child: const Icon(Icons.multitrack_audio),
                      foregroundColor: AppColor.yellowColor,
                      label: "Instant",
                      onTap: () async {
                        await Get.delete<CreateRoomController>();
                        controller.setIndex(2);
                      },
                    ),
                    SpeedDialChild(
                      child: const Icon(Icons.date_range),
                      foregroundColor: AppColor.yellowColor,
                      label: "Schedule",
                      onTap: () => {},
                    ),
                  ],
                )
              : FloatingActionButton(
                  onPressed: () async {
                    await Get.find<CreateRoomController>().createRoom();
                  },
                  backgroundColor: AppColor.yellowColor,
                  child: const Icon(Icons.done)),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
          body: (controller.getIndex() == 0)
              ? HomeScreen()
              : (controller.getIndex() == 2)
                  ? CreateRoomScreen()
                  : const DiscussionScreen(),
        ));
  }
}
