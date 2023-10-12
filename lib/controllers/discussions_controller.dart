import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:resonate/services/appwrite_service.dart';

class DiscussionsController extends GetxController {
  final Databases databases = AppwriteService.getDatabases();
  TextEditingController dateTimeController = TextEditingController(text: "");
  late List<Document> discussions;

  @override
  void onInit() async {
    super.onInit();
    await getDiscussions();
  }

  Future<void> createDiscussion() async {}

  Future<void> chooseDateTime() async {
    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(1800),
      lastDate: DateTime.now(),
    );
    int initialMinute = TimeOfDay.now().minute + 5;
    TimeOfDay initalTime =
        TimeOfDay(hour: TimeOfDay.now().hour, minute: initialMinute);
    TimeOfDay? pickedTime = await showTimePicker(
      context: Get.context!,
      initialTime: initalTime,
    );
    if (pickedDate != null && pickedTime != null) {
      dateTimeController.text =
          DateFormat("dd-MM-yyyy").format(pickedDate).toString() +
              " " +
              pickedTime.hour.toString() +
              ":" +
              pickedTime.minute.toString();
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
