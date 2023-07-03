import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:textfield_tags/textfield_tags.dart';

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
      log("${nameController.text} - ${descriptionController.text} - ${tagsController.getTags} ");
      //TODO: Make a call to createRoom method from RoomService class
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
      print("hu kano");
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
