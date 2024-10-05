import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/controllers/create_room_controller.dart';
import 'package:resonate/controllers/upcomming_rooms_controller.dart';
import 'package:resonate/controllers/pair_chat_controller.dart';
import 'package:resonate/controllers/rooms_controller.dart';
import 'package:resonate/controllers/tabview_controller.dart';
import 'package:resonate/themes/theme_controller.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/views/screens/create_room_screen.dart';
import 'package:resonate/views/screens/explore_screen.dart';
import 'package:resonate/views/screens/home_screen.dart';
import 'package:resonate/views/widgets/profile_avatar.dart';

import '../../controllers/email_verify_controller.dart';
import '../../utils/utils.dart';
import '../widgets/pair_chat_dialog.dart';

class TabViewScreen extends StatelessWidget {
  final CreateRoomController createRoomController =
      Get.find<CreateRoomController>();
  final TabViewController controller = Get.find<TabViewController>();
  final AuthStateController authStateController =
      Get.put<AuthStateController>(AuthStateController());
  final emailVerifyController =
      Get.put<EmailVerifyController>(EmailVerifyController());
  final RoomsController roomsController = Get.find<RoomsController>();
  final upcomingRoomsController =
      Get.put<UpcomingRoomsController>(UpcomingRoomsController());
  final ThemeController themeController = Get.find<ThemeController>();

  TabViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            toolbarHeight: UiSizes.size_56,
            automaticallyImplyLeading: false,
            title: Text(
              "Resonate",
              style: TextStyle(
                  fontSize: UiSizes.size_26,
                  color: Theme.of(context).colorScheme.primary),
            ),
            centerTitle: false,
            actions: [
              SizedBox(
                height: UiSizes.height_45,
                child: const Icon(
                  Icons.notifications_none_rounded,
                  size: 30,
                ),
              ),
              const SizedBox(width: 15),
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
                          controller.setIndex(2);
                        } else {
                          AppUtils.showDialog(
                            context: context,
                            title: "Email Verification Required",
                            middleText:
                                "To proceed, verify your email address.",
                            onFirstBtnPressed: () {
                              Get.back();
                              emailVerifyController.isSending.value = true;
                              emailVerifyController.sendOTP();
                              AppUtils.showBlurredLoaderDialog(context);
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
                        buildPairChatDialog(context);
                      },
                    ),
                  ],
                )
              : SizedBox(
                  height: UiSizes.height_56,
                  width: UiSizes.width_56,
                  child: FloatingActionButton(
                      onPressed: () async {
                        if (createRoomController.isScheduled.value) {
                          createRoomController.isLoading.value = true;
                          await upcomingRoomsController.createUpcomingRoom();
                          upcomingRoomsController.getUpcomingRooms();
                          createRoomController.isLoading.value = false;
                          controller.setIndex(3);
                        } else {
                          await createRoomController.createRoom(
                              createRoomController.nameController.text,
                              createRoomController.descriptionController.text,
                              createRoomController.tagsController.getTags!.map((item) => item.toString())
                                  .toList(),
                              true);
                          await roomsController.getRooms();
                        }
                      },
                      child: Icon(Icons.done, size: UiSizes.size_24)),
                ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: AnimatedBottomNavigationBar(
            height: UiSizes.size_56,
            activeColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.secondary,
            inactiveColor: Theme.of(context).brightness == Brightness.light
                ? Colors.black.withOpacity(0.3)
                : Colors.white.withOpacity(0.3),
            splashRadius: 0,
            shadow: const Shadow(color: Colors.transparent),
            iconSize: UiSizes.size_30,
            icons: const [Icons.home_rounded, Icons.search],
            leftCornerRadius: 30.0,
            rightCornerRadius: 30.0,
            notchMargin: UiSizes.size_8,
            activeIndex: controller.getIndex(),
            gapLocation: GapLocation.center,
            notchSmoothness: NotchSmoothness.defaultEdge,
            borderWidth: 0.0,
            borderColor: Colors.transparent,
            onTap: (index) => controller.setIndex(index),
          ),
          body: (controller.getIndex() == 0)
              ? const HomeScreen()
              : (controller.getIndex() == 2)
                  ? CreateRoomScreen()
                  : const ExploreScreen(),
        ));
  }
}
