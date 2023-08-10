import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/models/appwrite_room.dart';
import 'package:resonate/utils/colors.dart';

import '../views/screens/room_screen.dart';

class TabViewController extends GetxController {
  final RxInt _selectedIndex = 0.obs;
  getIndex() => _selectedIndex.value;
  setIndex(index) => _selectedIndex.value = index;

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


