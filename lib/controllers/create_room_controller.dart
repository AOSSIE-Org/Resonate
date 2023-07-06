import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/controllers/tabview_controller.dart';
import 'package:textfield_tags/textfield_tags.dart';

import '../services/room_service.dart';

class CreateRoomController extends GetxController {
  RxBool isLoading = false.obs;

  GlobalKey<FormState> createRoomFormKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextfieldTagsController tagsController = TextfieldTagsController();

  Future<void> createRoom() async {
    if (!createRoomFormKey.currentState!.validate()) {
      return;
    }
    try {
      isLoading.value = true;

      // Create a new room and add current user to participant list as admin and join livekit room
      AuthStateController authStateController = Get.find<AuthStateController>();
      await RoomService.createRoom(
          roomName: nameController.text,
          roomDescription: descriptionController.text,
          roomTags: tagsController.getTags!,
          adminEmail: authStateController.email!,
          adminUid: authStateController.uid!);

      // Open the Room Bottom Sheet to interact in the room
      Get.find<TabViewController>().openRoomSheet();

    } catch (e) {
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}

extension Validator on String {
  bool isValidTag() {
    // Remove any leading or trailing whitespaces
    String hashtag = this.trim();

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
