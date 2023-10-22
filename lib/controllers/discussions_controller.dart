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
  late Document currentUserDoc;
  Rx<bool> isLoading = false.obs;
  final Map<String, String> monthMap = {
    "1": "Jan",
    "2": "Feb",
    "3": "March",
    "5": "May",
    "4": "April",
    "6": "June",
    "7": "July",
    "8": "Aug",
    "9": "Sep",
    "10": "Oct",
    "11": "Nov",
    "12": "Dec",
  };
  @override
  void onInit() async {
    super.onInit();
    await getDiscussions();
  }

  Future<void> addUserToSubscriberList(String discussionId) async {
    await databases.createDocument(
        databaseId: "6522fcf27a1bbc4238df",
        collectionId: "6522fd267db6fdad3392",
        documentId: ID.unique(),
        data: {
          "UserID": authStateController.uid,
          "DiscussionID": discussionId,
          "RegistrationID": "Test",
          "isCreator": false,
          "UserProfileUrl": authStateController.profileImageUrl
        });
  }

  Future<void> removeUserFromSubscriberList(String subscriberId) async {
    await databases.deleteDocument(
        databaseId: "6522fcf27a1bbc4238df",
        collectionId: "6522fd267db6fdad3392",
        documentId: subscriberId);
  }

  Future<List<dynamic>> fetchDiscussionDetails(String discussionId) async {
    try {
      List<Document> discussionSubscribers;
      int totalSubscriberCount;
      bool? userIsCreator = null;
      String? subscriberId = null;
      discussionSubscribers = await databases.listDocuments(
          databaseId: '6522fcf27a1bbc4238df',
          collectionId: '6522fd267db6fdad3392',
          queries: [
            Query.equal('DiscussionID', ['${discussionId}']),
          ]).then((value) => value.documents);
      totalSubscriberCount = discussionSubscribers.length;

      List<String> subscribersProfileUrls = [];

      for (var doc in discussionSubscribers) {
        subscribersProfileUrls.add(doc.data["UserProfileUrl"]);
      }

      print(subscribersProfileUrls);
      for (var doc in discussionSubscribers) {
        if (doc.data["UserID"] == authStateController.uid) {
          userIsCreator = doc.data["isCreator"];

          if (doc.data["isCreator"] == false) {
            subscriberId = doc.$id;
          }
        }
      }
      print(userIsCreator);
      List<dynamic> fetchedData = [
        totalSubscriberCount,
        userIsCreator,
        subscribersProfileUrls,
        subscriberId
      ];
      return fetchedData;
    } catch (e) {
      log(e.toString());
      return [];
    }
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
            "Tags": createRoomController.tagsController.getTags
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
            "isCreator": true,
            "UserProfileUrl": authStateController.profileImageUrl
          });
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> chooseDateTime() async {
    DateTime now = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(DateTime.now().year + 1, now.month, now.day),
    );
    DateTime initialTime = now.add(const Duration(minutes: 5));

    TimeOfDay? pickedTime = await showTimePicker(
      context: Get.context!,
      initialTime:
          TimeOfDay(hour: initialTime.hour, minute: initialTime.minute),
    );
    if (pickedDate != null && pickedTime != null) {
      DateTime pickedDateTime = DateTime(pickedDate.year, pickedDate.month,
          pickedDate.day, pickedTime.hour, pickedTime.minute);
      if (!pickedDateTime.isAfter(now)) {
        Get.snackbar("Invalid Scheduled Date Time",
            "Scheduled Date Time cannot be in past");
        return;
      }
      scheduledDateTime =
          '${DateFormat("yyyy-MM-dd").format(pickedDate).toString()}T${pickedTime.hour.toString()}:${pickedTime.minute.toString()}:00';
      dateTimeController.text =
          '${pickedDate.day}  ${monthMap[pickedDate.month.toString()]}  ${pickedDate.year}  ${pickedTime.hour.toString()}:${pickedTime.minute.toString().length < 2 ? '0${pickedTime.minute}' : pickedTime.minute.toString()}  ${pickedTime.period.name.toUpperCase()}';
      print(dateTimeController.text);
    }
  }

  Future<void> getDiscussions() async {
    isLoading.value = true;
    try {
      discussions = await databases
          .listDocuments(
            databaseId: '6522fcf27a1bbc4238df',
            collectionId: '6522fd163103bd453183',
          )
          .then((value) => value.documents);
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading.value = false;
      update();
    }
  }
}
