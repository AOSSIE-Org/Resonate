//import required packages
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
  //reactive variable
  final RxInt _selectedIndex = 0.obs;

  //getter returning value stored in _selectedIndex
  getIndex() => _selectedIndex.value;
  //setter modifying the value stored in _selectedIndex
  setIndex(index) => _selectedIndex.value = index;
  //AppLinks is provided by app_links package
  //AppLinks allows the links to be opened in app instead of Browser
  late AppLinks _appLinks;
  //StreamSubscription listens to the events and holds the callback
  StreamSubscription<Uri>? _linkSubscription;

  //call initAppLinks() method when controller initializes
  @override
  void onInit() {
    super.onInit();
    initAppLinks();
  }

  //cancel the _linkSubscription when the controller is removed from memory
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

  //openAppLink() method takes a URL(URL to join AppWrite Room) and display option to join the room
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

  //openRoomSheet() takes an AppwriteRoom called room and uses showModalBottomSheet() from flutter material library to build rooms 
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
      enableDrag: true,
      isDismissible: false,
    );
  }
}
