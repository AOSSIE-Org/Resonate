import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/controllers/create_room_controller.dart';
import 'package:resonate/services/appwrite_service.dart';

class DiscussionsController extends GetxController {
  final Databases databases = AppwriteService.getDatabases();
  TextEditingController dateTimeController = TextEditingController(text: "");
  AuthStateController authStateController = Get.find<AuthStateController>();
  final CreateRoomController createRoomController =
      Get.find<CreateRoomController>();
  late List<Document> discussions;
  late String scheduledDateTime;

  @override
  void onInit() async {
    super.onInit();
    await getDiscussions();
  }

  Future<void> createDiscussion() async {
    if (!createRoomController.createRoomFormKey.currentState!.validate()) {
      return;
    }
    try {
      Document discussion = await databases.createDocument(
          databaseId: "6522fcf27a1bbc4238df",
          collectionId: "6522fd163103bd453183",
          documentId: ID.unique(),
          data: {
            "Name": createRoomController.nameController.text,
            "ScheduledDateTime": scheduledDateTime,
          });
      String discussionId = discussion.$id;
      await databases.createDocument(
          databaseId: "6522fcf27a1bbc4238df",
          collectionId: "6522fd267db6fdad3392",
          documentId: ID.unique(),
          data: {
            "UserID": authStateController.uid,
            "DiscussionID": discussionId,
            "RegistrationID": "Test",
            "isCreator": true
          });
    } catch (e) {
      log(e.toString());
    }
  }

  bool isTimeValid(TimeOfDay time) {
    bool isValidTime;
    int nowHour = TimeOfDay.now().hour;
    int nowMinute = TimeOfDay.now().minute;
    print('${time.hour}.  ${time.minute}');
    print('${nowHour}.  ${nowMinute}');
    if (nowHour < time.hour) {
      isValidTime = true;
    } else if (nowHour == time.hour && nowMinute < time.minute) {
      isValidTime = true;
    } else {
      isValidTime = false;
    }
    return isValidTime;
  }

  Future<void> chooseDateTime() async {
    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(
          DateTime.now().year + 1, DateTime.now().month, DateTime.now().day),
    );
    int initialMinute = TimeOfDay.now().minute + 5;
    TimeOfDay initalTime =
        TimeOfDay(hour: TimeOfDay.now().hour, minute: initialMinute);
    TimeOfDay? pickedTime = await showTimePicker(
      context: Get.context!,
      initialTime: initalTime,
    );
    if (pickedDate != null && pickedTime != null) {
      if (!isTimeValid(pickedTime)) {
        Get.snackbar("Invalid Scheduled Date Time",
            "Scheduled Date Time cannot be in past");
        return;
      }
      scheduledDateTime =
          '${DateFormat("yyyy-MM-dd").format(pickedDate).toString()}T${pickedTime.hour.toString()}:${pickedTime.minute.toString()}:00';
      dateTimeController.text =
          'Date: ${DateFormat("yyyy-MM-dd").format(pickedDate).toString()}   Time: ${pickedTime.hour.toString()}:${pickedTime.minute.toString()}:00';
      print(dateTimeController.text);
    }
  }

  Future<void> getDiscussions() async {
    discussions = await databases
        .listDocuments(
          databaseId: '6522fcf27a1bbc4238df',
          collectionId: '6522fd163103bd453183',
        )
        .then((value) => value.documents);
  }
}
