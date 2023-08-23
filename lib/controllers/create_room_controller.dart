import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/controllers/tabview_controller.dart';
import 'package:resonate/utils/enums/room_state.dart';
import 'package:textfield_tags/textfield_tags.dart';

import '../models/appwrite_room.dart';
import '../services/room_service.dart';

class CreateRoomController extends GetxController {
  RxBool isLoading = false.obs;

  GlobalKey<FormState> createRoomFormKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextfieldTagsController tagsController = TextfieldTagsController();

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    tagsController.dispose();
    super.dispose();
  }

  Future<void> createRoom() async {
    if (!createRoomFormKey.currentState!.validate()) {
      return;
    }
    try {
      isLoading.value = true;

      // Display Loading Dialog
      Get.dialog(
          Center(
            child: LoadingAnimationWidget.threeRotatingDots(
                color: Colors.amber, size: Get.pixelRatio * 20),
          ),
          barrierDismissible: false,
          name: "Loading Dialog");

      // Create a new room and add current user to participant list as admin and join livekit room
      AuthStateController authStateController = Get.find<AuthStateController>();
      List<String> newRoomInfo = await RoomService.createRoom(
          roomName: nameController.text,
          roomDescription: descriptionController.text,
          roomTags: tagsController.getTags!,
          adminUid: authStateController.uid!);
      String newRoomId = newRoomInfo[0];
      String myDocId = newRoomInfo[1];

      // Close the loading dialog
      Get.back();

      // Open the Room Bottom Sheet to interact in the room
      AppwriteRoom room = AppwriteRoom(
          id: newRoomId,
          name: nameController.text,
          description: descriptionController.text,
          totalParticipants: 1,
          tags: tagsController.getTags!,
          memberAvatarUrls: [],
          state: RoomState.live,
          myDocId: myDocId,
          isUserAdmin: true);
      Get.find<TabViewController>().openRoomSheet(room);

      // Clear Create Room Form
      nameController.clear();
      tagsController.clearTags();
      descriptionController.clear();
    } catch (e) {
      log(e.toString());

      // Close the loading dialog
      Get.back();
    } finally {
      isLoading.value = false;
    }
  }
}

extension Validator on String {
  bool isValidTag() {
    // Remove any leading or trailing whitespaces
    String hashtag = trim();

    // Check if the hashtag starts with a letter or number
    if (!hashtag.startsWith(RegExp(r'[a-zA-Z0-9]'))) {
      return false;
    }

    // Check if the hashtag contains only letters, numbers, or underscores
    if (!hashtag.contains(RegExp(r'^[a-zA-Z0-9_]+$'))) {
      return false;
    }

    // Check if the hashtag is not too long
    if (hashtag.length > 30) {
      return false;
    }

    return true;
  }
}
