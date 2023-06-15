import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:resonate/utils/colors.dart';
import 'package:resonate/views/widgets/participant_block.dart';

import '../models/participant.dart';
import '../views/screens/room_screen.dart';

class TabViewController extends GetxController {
  RxInt _selectedIndex = 0.obs;
  getIndex() => _selectedIndex.value;
  setIndex(index) => _selectedIndex.value = index;

  void openRoomSheet() {
    showModalBottomSheet(
        context: Get.context!,
        builder: (ctx) {
          return RoomScreen();
        },
        useSafeArea: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        backgroundColor: AppColor.bgBlackColor,
        isScrollControlled: true,
        enableDrag: true,
        isDismissible: false);
  }
}


