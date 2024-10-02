import 'dart:developer';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/controllers/rooms_controller.dart';
import 'package:resonate/models/appwrite_room.dart';
import 'package:resonate/models/appwrite_upcomming_room.dart';
import 'package:resonate/themes/theme_controller.dart';
import 'package:resonate/controllers/create_room_controller.dart';
import 'package:resonate/controllers/tabview_controller.dart';
import 'package:resonate/services/appwrite_service.dart';
import 'package:resonate/utils/constants.dart';

class UpcomingRoomsController extends GetxController {
  final Databases databases = AppwriteService.getDatabases();
  TextEditingController dateTimeController = TextEditingController(text: "");
  AuthStateController authStateController = Get.find<AuthStateController>();
  final CreateRoomController createRoomController =
      Get.find<CreateRoomController>();
  Rx<ScrollController> upcomingRoomScrollController = ScrollController().obs;
  final TabViewController controller = Get.find<TabViewController>();
  final ThemeController themeController = Get.find<ThemeController>();
  final RoomsController roomsController = Get.find<RoomsController>();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  late List<AppwriteUpcommingRoom> upcomingRooms;
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
    await getUpcomingRooms();
  }

  Future<void> addUserToSubscriberList(String upcomingRoomId) async {
    final fcmToken = await messaging.getToken();
    await databases.createDocument(
        databaseId: upcomingRoomsDatabaseId,
        collectionId: subscribedUserCollectionId,
        documentId: ID.unique(),
        data: {
          "userID": authStateController.uid,
          "upcomingRoomId": upcomingRoomId,
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
            "baseColor": const Color.fromARGB(255, 71, 70, 70),
            "highlightColor": const Color.fromARGB(255, 94, 94, 94)
          };
    return shimmerColor;
  }

  Future<void> removeUserFromSubscriberList(String subscriberId) async {
    try {
      await databases.deleteDocument(
          databaseId: upcomingRoomsDatabaseId,
          collectionId: subscribedUserCollectionId,
          documentId: subscriberId);
    } on AppwriteException catch (error) {
      log(error.toString());
    }
  }

  Future<AppwriteUpcommingRoom> fetchUpcomingRoomDetails(
      Document upcomingRoom) async {
    try {
      List<Document> upcomingRoomSubscribers;
      int totalSubscriberCount;
      bool userIsCreator =
          (authStateController.uid == upcomingRoom.data["creatorUid"]);
      bool hasUserSubscribed = false;

      upcomingRoomSubscribers = await databases.listDocuments(
          databaseId: upcomingRoomsDatabaseId,
          collectionId: subscribedUserCollectionId,
          queries: [
            Query.equal('upcomingRoomId', [upcomingRoom.$id]),
          ]).then((value) => value.documents);
      totalSubscriberCount = upcomingRoomSubscribers.length;

      List<String> subscribersProfileUrls = [];

      for (var doc in upcomingRoomSubscribers) {
        subscribersProfileUrls.add(doc.data["userProfileUrl"]);

        if (!userIsCreator) {
          if (doc.data['userID'] == authStateController.uid) {
            hasUserSubscribed = true;
          }
        }
      }

      currentTimeInstance = DateTime.now();
      localTimeZoneOffset = currentTimeInstance.timeZoneOffset;
      localTimeZoneName = currentTimeInstance.timeZoneName;
      isOffsetNegetive = localTimeZoneOffset.isNegative;

      return AppwriteUpcommingRoom(
          id: upcomingRoom.$id,
          name: upcomingRoom.data['name'],
          isTime: upcomingRoom.data['isTime'],
          scheduledDateTime: upcomingRoom.data['scheduledDateTime'],
          totalSubscriberCount: totalSubscriberCount,
          tags: upcomingRoom.data['tags'],
          subscribersAvatarUrls: subscribersProfileUrls,
          userIsCreator: userIsCreator,
          description: upcomingRoom.data['isTime'],
          hasUserSubscribed: hasUserSubscribed);
    } catch (e) {
      log(e.toString());
      return AppwriteUpcommingRoom(
        id: '', // Provide some default/fallback values
        name: 'Unknown',
        isTime: false,
        scheduledDateTime: DateTime.now(),
        totalSubscriberCount: 0,
        tags: [],
        subscribersAvatarUrls: [],
        userIsCreator: false,
        description: 'Error fetching upcomingRoom details',
        hasUserSubscribed: false,
      );
    }
  }

  Future<void> getUpcomingRooms() async {
    isLoading.value = true;
    try {
      var upcomingRooms_documents = await databases
          .listDocuments(
            databaseId: upcomingRoomsDatabaseId,
            collectionId: upcomingRoomsCollectionId,
          )
          .then((value) => value.documents);
      upcomingRooms = [];

      for (var upcomingRoom in upcomingRooms_documents) {
        AppwriteUpcommingRoom appwriteUpcomingRoom =
            await fetchUpcomingRoomDetails(upcomingRoom);
        upcomingRooms.add(appwriteUpcomingRoom);
      }
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> convertUpcomingRoomtoRoom(String upcomingRoomId, String name,
      String description, List<String> tags) async {
    await createRoomController.createRoom(name, description, tags, false);
    controller.setIndex(0);

    await roomsController.getRooms();
    // Delete UpcomingRoom as it is now a room
    await databases.deleteDocument(
      databaseId: upcomingRoomsDatabaseId,
      collectionId: upcomingRoomsCollectionId,
      documentId: upcomingRoomId,
    );
    await getUpcomingRooms();
  }

  Future<void> createUpcomingRoom() async {
    final fcmToken = await messaging.getToken();
    if (!createRoomController.createRoomFormKey.currentState!.validate()) {
      return;
    }
    try {
      Document upcomingRoomDoc = await databases.createDocument(
          databaseId: upcomingRoomsDatabaseId,
          collectionId: upcomingRoomsCollectionId,
          documentId: ID.unique(),
          data: {
            "name": createRoomController.nameController.text,
            "scheduledDateTime": scheduledDateTime,
            "tags": createRoomController.tagsController.getTags,
            "description": createRoomController.descriptionController.text
          });
      String upcomingRoomId = upcomingRoomDoc.$id;
      await databases.createDocument(
          databaseId: upcomingRoomsDatabaseId,
          collectionId: subscribedUserCollectionId,
          documentId: ID.unique(),
          data: {
            "userID": authStateController.uid,
            "upcomingRoomId": upcomingRoomId,
            "registrationTokens": [fcmToken],
            "isCreator": true,
            "userProfileUrl": authStateController.profileImageUrl
          });
    } on AppwriteException catch (e) {
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
          '${removedMinusHour.length < 2 ? '0$removedMinusHour' : removedMinusHour}:${splittedOffset[1].length < 2 ? '0${splittedOffset[1]}' : splittedOffset[1]}';
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
          '${DateFormat("yyyy-MM-dd").format(pickedDate).toString()}T${pickedTime.hour.toString()}:${pickedTime.minute.toString()}:00${isOffsetNegetive ? '-' : '+'}$formattedOffset';
      dateTimeController.text =
          '${pickedDate.day}  ${monthMap[pickedDate.month.toString()]}  ${pickedDate.year}  ${pickedTime.hour > 12 ? (pickedTime.hour - 12) : pickedTime.hour == 0 ? '00' : pickedTime.hour}:${pickedTime.minute.toString().length < 2 ? '0${pickedTime.minute}' : pickedTime.minute.toString()}  ${pickedTime.period.name.toUpperCase()}';
    }
  }

  Future<void> deleteUpcomingRoom(String upcomingRoomId) async {
    await databases.deleteDocument(
        databaseId: upcomingRoomsDatabaseId,
        collectionId: upcomingRoomsCollectionId,
        documentId: upcomingRoomId);
    await getUpcomingRooms();
    deleteAllDeletedUpcomingRoomsSubscribers(upcomingRoomId);
  }

  Future<void> deleteAllDeletedUpcomingRoomsSubscribers(
      String upcomingRoomId) async {
    List<Document> deletedUpcomingRoomSubscribers = await databases.listDocuments(
        databaseId: upcomingRoomsDatabaseId,
        collectionId: subscribedUserCollectionId,
        queries: [
          Query.equal('upcomingRoomId', [upcomingRoomId]),
        ]).then((value) => value.documents);

    for (Document subscriber in deletedUpcomingRoomSubscribers) {
      await databases.deleteDocument(
          databaseId: upcomingRoomsDatabaseId,
          collectionId: subscribedUserCollectionId,
          documentId: subscriber.$id);
    }
  }
}
