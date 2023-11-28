import 'dart:developer';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/controllers/rooms_controller.dart';
import 'package:resonate/themes/theme_controller.dart';
import 'package:resonate/controllers/create_room_controller.dart';
import 'package:resonate/controllers/tabview_controller.dart';
import 'package:resonate/services/appwrite_service.dart';

class DiscussionsController extends GetxController {
  final Databases databases = AppwriteService.getDatabases();
  TextEditingController dateTimeController = TextEditingController(text: "");
  AuthStateController authStateController = Get.find<AuthStateController>();
  final CreateRoomController createRoomController =
      Get.find<CreateRoomController>();
  Rx<ScrollController> discussionScrollController = ScrollController().obs;
  final TabViewController controller = Get.find<TabViewController>();
  final ThemeController themeController = Get.find<ThemeController>();
  final RoomsController roomsController = Get.find<RoomsController>();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  late List<Document> discussions;
  late String scheduledDateTime;
  late Document currentUserDoc;
  late Duration localTimeZoneOffset;
  late String localTimeZoneName;
  late bool isOffsetNegetive;
  Rx<bool> isLoading = false.obs;
  late DateTime currentTimeInstance;
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
    final fcmToken = await messaging.getToken();
    await databases.createDocument(
        databaseId: "6522fcf27a1bbc4238df",
        collectionId: "6522fd267db6fdad3392",
        documentId: ID.unique(),
        data: {
          "userID": authStateController.uid,
          "discussionID": discussionId,
          "registrationTokens": [fcmToken],
          "isCreator": false,
          "userProfileUrl": authStateController.profileImageUrl
        });
  }

  Map<String, Color> getShimmerColor() {
    Map<String, Color> shimmerColor;
    themeController.loadTheme() == 'light'
        ? shimmerColor = {
            "baseColor": Colors.grey.shade300,
            "highlightColor": Colors.grey.shade100
          }
        : shimmerColor = {
            "baseColor": Color.fromARGB(255, 71, 70, 70),
            "highlightColor": Color.fromARGB(255, 94, 94, 94)
          };
    return shimmerColor;
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
            Query.equal('discussionID', ['${discussionId}']),
          ]).then((value) => value.documents);
      totalSubscriberCount = discussionSubscribers.length;

      List<String> subscribersProfileUrls = [];

      for (var doc in discussionSubscribers) {
        subscribersProfileUrls.add(doc.data["userProfileUrl"]);
      }
      for (var doc in discussionSubscribers) {
        if (doc.data["userID"] == authStateController.uid) {
          userIsCreator = doc.data["isCreator"];

          if (doc.data["isCreator"] == false) {
            subscriberId = doc.$id;
          }
        }
      }
      currentTimeInstance = DateTime.now();
      localTimeZoneOffset = currentTimeInstance.timeZoneOffset;
      localTimeZoneName = currentTimeInstance.timeZoneName;
      isOffsetNegetive = localTimeZoneOffset.isNegative;
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

  Future<void> convertDiscussiontoRoom(String discussionId, String name,
      String description, List<String> tags) async {
    await createRoomController.createRoom(name, description, tags, false);
    controller.setIndex(0);

    await roomsController.getRooms();
    // Delete Discussion as it is now a room
    await databases.deleteDocument(
      databaseId: '6522fcf27a1bbc4238df',
      collectionId: '6522fd163103bd453183',
      documentId: '${discussionId}',
    );
    await getDiscussions();
  }

  Future<void> createDiscussion() async {
    final fcmToken = await messaging.getToken();
    if (!createRoomController.createRoomFormKey.currentState!.validate()) {
      return;
    }
    try {
      Document discussion = await databases.createDocument(
          databaseId: "6522fcf27a1bbc4238df",
          collectionId: "6522fd163103bd453183",
          documentId: ID.unique(),
          data: {
            "name": createRoomController.nameController.text,
            "scheduledDateTime": scheduledDateTime,
            "tags": createRoomController.tagsController.getTags
          });
      String discussionId = discussion.$id;
      await databases.createDocument(
          databaseId: "6522fcf27a1bbc4238df",
          collectionId: "6522fd267db6fdad3392",
          documentId: ID.unique(),
          data: {
            "userID": authStateController.uid,
            "discussionID": discussionId,
            "registrationTokens": [fcmToken],
            "isCreator": true,
            "userProfileUrl": authStateController.profileImageUrl
          });
    } catch (e) {
      log(e.toString());
    }
  }

  String formatTimeZoneOffset(String offset, bool isNegative) {
    String formattedOffset;
    List<String> splittedOffset = offset.split(":");
    if (isNegative) {
      List<String> removingMinus = splittedOffset[0].split('-');
      String removedMinusHour = removingMinus[1];
      formattedOffset =
          '${removedMinusHour.length < 2 ? '0${removedMinusHour}' : removedMinusHour}:${splittedOffset[1].length < 2 ? '0${splittedOffset[1]}' : splittedOffset[1]}';
    } else {
      formattedOffset =
          '${splittedOffset[0].length < 2 ? '0${splittedOffset[0]}' : splittedOffset[0]}:${splittedOffset[1].length < 2 ? '0${splittedOffset[1]}' : splittedOffset[1]}';
    }
    return formattedOffset;
  }

  Future<void> chooseDateTime() async {
    DateTime now = DateTime.now();
    Duration timeZoneOffset = now.timeZoneOffset;
    String timeZoneOffsetString = timeZoneOffset.toString();
    bool isOffsetNegetive = timeZoneOffset.isNegative;
    String formattedOffset =
        formatTimeZoneOffset(timeZoneOffsetString, isOffsetNegetive);
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
          '${DateFormat("yyyy-MM-dd").format(pickedDate).toString()}T${pickedTime.hour.toString()}:${pickedTime.minute.toString()}:00${isOffsetNegetive ? '-' : '+'}${formattedOffset}';
      dateTimeController.text =
          '${pickedDate.day}  ${monthMap[pickedDate.month.toString()]}  ${pickedDate.year}  ${pickedTime.hour > 12 ? (pickedTime.hour - 12) : pickedTime.hour == 0 ? '00' : pickedTime.hour}:${pickedTime.minute.toString().length < 2 ? '0${pickedTime.minute}' : pickedTime.minute.toString()}  ${pickedTime.period.name.toUpperCase()}';
    }
  }

  Future<void> deleteDiscussion(String discussionId) async {
    await databases.deleteDocument(
        databaseId: "6522fcf27a1bbc4238df",
        collectionId: "6522fd163103bd453183",
        documentId: discussionId);
    await getDiscussions();
    deleteAllDeletedDiscussionsSubscribers(discussionId);
  }

  Future<void> deleteAllDeletedDiscussionsSubscribers(
      String discussionId) async {
    List<Document> deletedDiscussionSubscribers = await databases.listDocuments(
        databaseId: '6522fcf27a1bbc4238df',
        collectionId: '6522fd267db6fdad3392',
        queries: [
          Query.equal('discussionID', ['${discussionId}']),
        ]).then((value) => value.documents);

    for (Document subscriber in deletedDiscussionSubscribers) {
      await databases.deleteDocument(
          databaseId: "6522fcf27a1bbc4238df",
          collectionId: "6522fd267db6fdad3392",
          documentId: subscriber.$id);
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
