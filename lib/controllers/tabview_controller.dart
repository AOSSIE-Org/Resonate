import 'dart:async';
import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/controllers/rooms_controller.dart';
import 'package:resonate/models/appwrite_room.dart';
import 'package:resonate/utils/colors.dart';
import 'package:resonate/views/widgets/room_tile.dart';

import '../views/screens/room_screen.dart';

class TabViewController extends GetxController {
  final RxInt _selectedIndex = 0.obs;
  getIndex() => _selectedIndex.value;
  setIndex(index) => _selectedIndex.value = index;

  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void onInit() {
    super.onInit();
    initAppLinks();
  }

  @override
  void onDispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> initAppLinks() async {
    _appLinks = AppLinks();

    // Check initial link if app was in cold state (terminated)
    final appLink = await _appLinks.getInitialAppLink();
    if (appLink != null) {
      log('getInitialAppLink: $appLink');
      openAppLink(appLink);
    }

    // Handle link when app is in warm state (front or background)
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      log('onAppLink: $uri');
      openAppLink(uri);
    });
  }

  void openAppLink(Uri uri) async {
    try {
      String roomId = uri.pathSegments.last;
      bool isUserLoggedIn = await Get.find<AuthStateController>().getLoginState;
      if (isUserLoggedIn) {
        AppwriteRoom appwriteRoom =
            await Get.find<RoomsController>().getRoomById(roomId);
        Get.defaultDialog(
            title: "Join Room",
            titleStyle: const TextStyle(color: Colors.amber, fontSize: 25),
            content: Column(
              children: [RoomTile(room: appwriteRoom)],
            ),
            backgroundColor: AppColor.bgBlackColor);
      }
    } catch (e) {
      log("Open App Link ERROR : ${e.toString()}");
    }
  }

  void openRoomSheet(AppwriteRoom room) {
    showModalBottomSheet(
        context: Get.context!,
        builder: (ctx) {
          return RoomScreen(room: room);
        },
        useSafeArea: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
        ),
        isScrollControlled: true,
        enableDrag: false,
        isDismissible: false);
  }
}
