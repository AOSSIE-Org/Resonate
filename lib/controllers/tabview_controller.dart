import 'dart:async';
import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/models/appwrite_room.dart';
import 'package:resonate/utils/colors.dart';

import '../views/screens/room_screen.dart';

class TabViewController extends GetxController {
  RxInt _selectedIndex = 0.obs;
  getIndex() => _selectedIndex.value;
  setIndex(index) => _selectedIndex.value = index;

  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  void onInit() {
    super.onInit();
    initAppLinks();
  }

  void onDispose(){
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

  void openAppLink(Uri uri) {
    log("Open Link Called");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.defaultDialog(title: uri.pathSegments.last);
    });
  }



  void openRoomSheet(AppwriteRoom room) {
    showModalBottomSheet(
        context: Get.context!,
        builder: (ctx) {
          return RoomScreen(room: room);
        },
        useSafeArea: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        backgroundColor: AppColor.bgBlackColor,
        isScrollControlled: true,
        enableDrag: false,
        isDismissible: false);
  }
}


