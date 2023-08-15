import 'dart:developer';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:language_picker/language_picker_dropdown.dart';
import 'package:language_picker/languages.dart';
import 'package:language_picker/languages.g.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/controllers/create_room_controller.dart';
import 'package:resonate/controllers/tabview_controller.dart';
import 'package:resonate/views/screens/discussions_screen.dart';
import 'package:resonate/views/screens/home_screen.dart';
import 'package:resonate/views/widgets/profile_avatar.dart';

import '../../controllers/email_verify_controller.dart';
import '../../utils/colors.dart';
import 'create_room_screen.dart';

class TabViewScreen extends StatelessWidget {
  final TabViewController controller = Get.put<TabViewController>(TabViewController());
  final AuthStateController authStateController = Get.put<AuthStateController>(AuthStateController());
  final EmailVerifyController emailverifycontroller = Get.find<EmailVerifyController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            toolbarHeight: (0.068 * Get.width + 0.034 * Get.height),
            automaticallyImplyLeading: false,
            title: Text(
              "Resonate",
              style: TextStyle(color: Colors.amber, fontSize: 0.0315 * Get.width + 0.01582 * Get.height),
            ),
            centerTitle: false,
            elevation: 10,
            backgroundColor: const Color.fromRGBO(17, 17, 20, 1),
            actions: [
              profileAvatar(context),
            ],
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
                      label: "Audio Room",
                      onTap: () async {
                        await Get.delete<CreateRoomController>();
                        controller.setIndex(2);
                      },
                    ),
                    SpeedDialChild(
                      child: const Icon(Icons.people_alt_rounded),
                      foregroundColor: AppColor.yellowColor,
                      label: "Pair Chat",
                      onTap: () => {
                        Get.defaultDialog(
                            title: "Pair Chat",
                            titleStyle: TextStyle(color: Colors.amber, fontSize: Get.pixelRatio * 10),
                            content: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Divider(),
                                  Text(
                                    "Choose Identity",
                                    style: TextStyle(color: Colors.amber, fontSize: Get.pixelRatio * 6),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          child: ElevatedButton(
                                            onPressed: () => {},
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: true ? AppColor.yellowColor : AppColor.bgBlackColor,
                                            ),
                                            child: Text(
                                              'Anonymous',
                                              style: TextStyle(
                                                color: true ? Colors.black : Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: false ? AppColor.yellowColor : AppColor.bgBlackColor,
                                            ),
                                            onPressed: () => {},
                                            child: FittedBox(
                                              fit: BoxFit.fitWidth,
                                              child: Text(
                                                Get.find<AuthStateController>().displayName!,
                                                style: TextStyle(
                                                  color: false ? Colors.black : Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Divider(),
                                  Text(
                                    "Select Language",
                                    style: TextStyle(color: Colors.amber, fontSize: Get.pixelRatio * 6),
                                  ),
                                  LanguagePickerDropdown(
                                      initialValue: Languages.english,
                                      onValuePicked: (Language language) {
                                        log(language.isoCode);
                                      }),
                                  const Divider(),
                                  ElevatedButton.icon(
                                    icon: Icon(
                                      Icons.people_outlined,
                                      color: Colors.black,
                                    ),
                                    onPressed: () =>{},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColor.yellowColor,
                                    ),
                                    label: Text(
                                      "Quick Match",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize:
                                        0.013 * Get.height + 0.026 * Get.width,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                      },
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
            height: 0.034 * Get.height + 0.068 * Get.width,
            backgroundColor: Colors.transparent,
            activeColor: Colors.amber,
            inactiveColor: Colors.amber.withOpacity(0.5),
            splashColor: Colors.black,
            shadow: const Shadow(color: Color.fromRGBO(17, 17, 20, 1)),
            iconSize: 0.01825 * Get.height + 0.0364 * Get.width,
            icons: const [
              Icons.home_outlined,
              // Icons.person_outline, // move to the appbar and replaced with discussions icon
              Icons.chat_rounded
            ],
            notchMargin: 0.009722 * Get.width + 0.00486 * Get.height,
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
