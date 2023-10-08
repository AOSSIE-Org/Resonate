import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/controllers/create_room_controller.dart';
import 'package:resonate/controllers/pair_chat_controller.dart';
import 'package:resonate/controllers/tabview_controller.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/views/screens/discussions_screen.dart';
import 'package:resonate/views/screens/home_screen.dart';
import 'package:resonate/views/widgets/profile_avatar.dart';

import '../../controllers/email_verify_controller.dart';
import '../../utils/utils.dart';
import '../widgets/pair_chat_dialog.dart';
import 'create_room_screen.dart';

class TabViewScreen extends StatelessWidget {
  final TabViewController controller =
      Get.put<TabViewController>(TabViewController());
  final AuthStateController authStateController =
      Get.put<AuthStateController>(AuthStateController());
  final emailVerifyController =
      Get.put<EmailVerifyController>(EmailVerifyController());

  TabViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            toolbarHeight: UiSizes.size_56,
            automaticallyImplyLeading: false,
            title: Text(
              "Resonate",
              style: TextStyle(fontSize: UiSizes.size_26),
            ),
            centerTitle: false,
            actions: [
              profileAvatar(context),
            ],
          ),
          floatingActionButton: (controller.getIndex() != 2)
              ? SpeedDial(
                  icon: Icons.add,
                  buttonSize: Size(UiSizes.width_56, UiSizes.height_56),
                  childrenButtonSize: Size(UiSizes.width_56, UiSizes.height_56),
                  activeIcon: Icons.close,
                  elevation: 8.0,
                  spacing: 10,
                  spaceBetweenChildren: 6,
                  animationCurve: Curves.elasticInOut,
                  children: [
                    SpeedDialChild(
                      child:
                          Icon(Icons.multitrack_audio, size: UiSizes.size_24),
                      label: "Audio Room",
                      labelStyle: TextStyle(fontSize: UiSizes.size_14),
                      onTap: () async {
                        if (authStateController.isEmailVerified!) {
                          await Get.delete<CreateRoomController>();
                          controller.setIndex(2);
                        } else {
                          AppUtils.showDialog(
                            title: "Email Verification Required",
                            middleText:
                                "To proceed, verify your email address first.",
                            onFirstBtnPressed: () {
                              Get.back();
                              emailVerifyController.isSending.value = true;
                              emailVerifyController.sendOTP();
                              AppUtils.showBlurredLoaderDialog();
                            },
                            onSecondBtnPressed: () => Get.back(),
                            firstBtnText: "Verify",
                          );
                        }
                      },
                    ),
                    SpeedDialChild(
                      child:
                          Icon(Icons.people_alt_rounded, size: UiSizes.size_24),
                      label: "Pair Chat",
                      labelStyle: TextStyle(fontSize: UiSizes.size_14),
                      onTap: () {
                        Get.put<PairChatController>(PairChatController());
                        buildPairChatDialog();
                      },
                    ),
                  ],
                )
              : SizedBox(
                  height: UiSizes.height_56,
                  width: UiSizes.width_56,
                  child: FloatingActionButton(
                      onPressed: () async {
                        await Get.find<CreateRoomController>().createRoom();
                      },
                      child: Icon(Icons.done, size: UiSizes.size_24)),
                ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: AnimatedBottomNavigationBar(
            height: UiSizes.size_56,
            backgroundColor: Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : const Color.fromRGBO(17, 17, 20, 1),
            activeColor: Colors.amber,
            inactiveColor: Theme.of(context).brightness == Brightness.light
                ? Colors.black.withOpacity(0.3)
                : Colors.white.withOpacity(0.3),
            splashRadius: 0,
            shadow: const Shadow(color: Colors.transparent),
            iconSize: UiSizes.size_30,
            icons: const [
              Icons.home_rounded,
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
