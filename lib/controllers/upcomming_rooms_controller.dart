import 'dart:developer';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/controllers/room_chat_controller.dart';
import 'package:resonate/controllers/rooms_controller.dart';
import 'package:resonate/models/appwrite_upcomming_room.dart';
import 'package:resonate/themes/theme_controller.dart';
import 'package:resonate/controllers/create_room_controller.dart';
import 'package:resonate/controllers/tabview_controller.dart';
import 'package:resonate/services/appwrite_service.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/views/screens/room_chat_screen.dart';
import 'package:resonate/views/widgets/snackbar.dart';

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
  late RxList<AppwriteUpcommingRoom> upcomingRooms =
      <AppwriteUpcommingRoom>[].obs;
  final GetStorage _storage = GetStorage();
  static const String _removedUpcomingRoomsKey = 'removed_upcoming_rooms';
  List<String> _removedRoomsList = [];
  late String scheduledDateTime;
  late Document currentUserDoc;
  late Duration localTimeZoneOffset;
  late String localTimeZoneName;
  late bool isOffsetNegetive;
  Rx<bool> isLoading = false.obs;
  RxBool searchBarIsEmpty = true.obs;
  RxList<AppwriteUpcommingRoom> filteredUpcomingRooms =
      <AppwriteUpcommingRoom>[].obs;
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
    _removedRoomsList = List<String>.from(
      _storage.read(_removedUpcomingRoomsKey) ?? [],
    );
    await getUpcomingRooms();
  }

  Future<void> cleanupRemovedRooms(List<String> existingRoomIds) async {
    try {
      int initialCount = _removedRoomsList.length;
      _removedRoomsList.removeWhere(
        (roomId) => !existingRoomIds.contains(roomId),
      );
      if (_removedRoomsList.length != initialCount) {
        await _storage.write(_removedUpcomingRoomsKey, _removedRoomsList);
        log(
          'Cleaned up ${initialCount - _removedRoomsList.length} non-existent rooms',
        );
      }
    } catch (e) {
      log('Error cleaning up removed rooms: ${e.toString()}');
    }
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
        "userProfileUrl": authStateController.profileImageUrl,
      },
    );

    await getUpcomingRooms();
  }

  Future<void> removeUserFromSubscriberList(String upcomingRoomId) async {
    try {
      var subscribeDocument = await databases
          .listDocuments(
            databaseId: upcomingRoomsDatabaseId,
            collectionId: subscribedUserCollectionId,
            queries: [
              Query.and([
                Query.equal('userID', authStateController.uid),
                Query.equal('upcomingRoomId', upcomingRoomId),
              ]),
            ],
          )
          .then((value) => value.documents.first);

      await databases.deleteDocument(
        databaseId: upcomingRoomsDatabaseId,
        collectionId: subscribedUserCollectionId,
        documentId: subscribeDocument.$id,
      );

      await getUpcomingRooms();
    } on AppwriteException catch (error) {
      log(error.toString());
    }
  }

  Future<AppwriteUpcommingRoom> fetchUpcomingRoomDetails(
    Document upcomingRoom,
  ) async {
    try {
      List<Document> upcomingRoomSubscribers;
      int totalSubscriberCount;
      bool userIsCreator =
          (authStateController.uid == upcomingRoom.data["creatorUid"]);
      bool hasUserSubscribed = false;

      upcomingRoomSubscribers = await databases
          .listDocuments(
            databaseId: upcomingRoomsDatabaseId,
            collectionId: subscribedUserCollectionId,
            queries: [
              Query.equal('upcomingRoomId', [upcomingRoom.$id]),
            ],
          )
          .then((value) => value.documents);
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
        scheduledDateTime: DateTime.parse(
          upcomingRoom.data['scheduledDateTime'],
        ),
        totalSubscriberCount: totalSubscriberCount,
        tags: upcomingRoom.data['tags'],
        subscribersAvatarUrls: subscribersProfileUrls,
        userIsCreator: userIsCreator,
        description: upcomingRoom.data['description'],
        hasUserSubscribed: hasUserSubscribed,
      );
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
      List<Document> upcomingRoomsDocuments = await databases
          .listDocuments(
            databaseId: upcomingRoomsDatabaseId,
            collectionId: upcomingRoomsCollectionId,
          )
          .then((value) => value.documents);
      List<Document> nonRemovedRooms = upcomingRoomsDocuments
          .where((room) => !_removedRoomsList.contains(room.$id))
          .toList();
      List<Future<AppwriteUpcommingRoom>> roomsFutures = nonRemovedRooms
          .map((room) => fetchUpcomingRoomDetails(room))
          .toList();
      upcomingRooms.value = await Future.wait(roomsFutures);
      await cleanupRemovedRooms(
        upcomingRoomsDocuments.map((doc) => doc.$id).toList(),
      );
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> convertUpcomingRoomtoRoom(
    String upcomingRoomId,
    String name,
    String description,
    List<String> tags,
  ) async {
    await createRoomController.createRoom(name, description, tags, false);
    controller.setIndex(0);
    await roomsController.getRooms();

    // Delete UpcomingRoom as it is now a room
    await deleteUpcomingRoom(upcomingRoomId);
    await getUpcomingRooms();
  }

  Future<void> createUpcomingRoom() async {
    if (!createRoomController.createRoomFormKey.currentState!.validate()) {
      return;
    }
    try {
      final fcmToken = await messaging.getToken();
      await databases.createDocument(
        databaseId: upcomingRoomsDatabaseId,
        collectionId: upcomingRoomsCollectionId,
        documentId: ID.unique(),
        data: {
          "name": createRoomController.nameController.text,
          "scheduledDateTime": scheduledDateTime,
          "tags": createRoomController.tagsController.getTags,
          "description": createRoomController.descriptionController.text,
          "creatorUid": authStateController.uid,
          "creator_fcm_tokens": [fcmToken],
        },
      );
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
    String formattedOffset = formatTimeZoneOffset(
      timeZoneOffsetString,
      isOffsetNegetive,
    );
    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(DateTime.now().year + 1, now.month, now.day),
    );
    DateTime initialTime = now.add(const Duration(minutes: 5));

    TimeOfDay? pickedTime = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay(
        hour: initialTime.hour,
        minute: initialTime.minute,
      ),
    );
    if (pickedDate != null && pickedTime != null) {
      DateTime pickedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      if (!pickedDateTime.isAfter(now)) {
        Get.snackbar(
          AppLocalizations.of(Get.context!)!.invalidScheduledDateTime,
          AppLocalizations.of(Get.context!)!.scheduledDateTimePast,
        );
        return;
      }
      scheduledDateTime =
          '${DateFormat("yyyy-MM-dd").format(pickedDate).toString()}T${pickedTime.hour.toString()}:${pickedTime.minute.toString()}:00${isOffsetNegetive ? '-' : '+'}$formattedOffset';
      dateTimeController.text =
          '${pickedDate.day}  ${monthMap[pickedDate.month.toString()]}  ${pickedDate.year}  ${pickedTime.hour > 12
              ? (pickedTime.hour - 12)
              : pickedTime.hour == 0
              ? '00'
              : pickedTime.hour}:${pickedTime.minute.toString().length < 2 ? '0${pickedTime.minute}' : pickedTime.minute.toString()}  ${pickedTime.period.name.toUpperCase()}';
    }
  }

  Future<void> removeUpcomingRoom(String upcomingRoomId) async {
    try {
      if (!_removedRoomsList.contains(upcomingRoomId)) {
        _removedRoomsList.add(upcomingRoomId);
        await _storage.write(_removedUpcomingRoomsKey, _removedRoomsList);
        log('Room $upcomingRoomId removed. Total: ${_removedRoomsList.length}');
      }
      upcomingRooms.removeWhere((room) => room.id == upcomingRoomId);
      update();
    } catch (e) {
      log("Error in Remove Upcoming Room Function: ${e.toString()}");
    }
  }

  Future<void> deleteUpcomingRoom(String upcomingRoomId) async {
    await databases.deleteDocument(
      databaseId: upcomingRoomsDatabaseId,
      collectionId: upcomingRoomsCollectionId,
      documentId: upcomingRoomId,
    );
    deleteAllDeletedUpcomingRoomsSubscribers(upcomingRoomId);
  }

  Future<void> deleteAllDeletedUpcomingRoomsSubscribers(
    String upcomingRoomId,
  ) async {
    List<Document> deletedUpcomingRoomSubscribers = await databases
        .listDocuments(
          databaseId: upcomingRoomsDatabaseId,
          collectionId: subscribedUserCollectionId,
          queries: [
            Query.equal('upcomingRoomId', [upcomingRoomId]),
          ],
        )
        .then((value) => value.documents);

    for (Document subscriber in deletedUpcomingRoomSubscribers) {
      await databases.deleteDocument(
        databaseId: upcomingRoomsDatabaseId,
        collectionId: subscribedUserCollectionId,
        documentId: subscriber.$id,
      );
    }
  }

  void openUpcomingChatSheet(AppwriteUpcommingRoom appwriteRoom) {
    showModalBottomSheet(
      context: Get.context!,
      builder: (ctx) {
        Get.put(RoomChatController(appwriteUpcommingRoom: appwriteRoom));
        return RoomChatScreen();
      },
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
      ),
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: false,
    );
  }

  Future<void> searchUpcomingRooms(String query) async {
    if (query.isEmpty) {
      filteredUpcomingRooms.value = upcomingRooms;
      searchBarIsEmpty.value = true;
      return;
    }

    searchBarIsEmpty.value = false;

    try {
      final lowerQuery = query.toLowerCase();
      filteredUpcomingRooms.value = upcomingRooms.where((room) {
        return room.name.toLowerCase().contains(lowerQuery) ||
            room.description.toLowerCase().contains(lowerQuery);
      }).toList();
    } catch (e) {
      filteredUpcomingRooms.value = upcomingRooms;
      customSnackbar(
        AppLocalizations.of(Get.context!)!.error,
        AppLocalizations.of(Get.context!)!.searchFailed,
        LogType.error,
      );
    }
  }

  void clearUpcomingSearch() {
    filteredUpcomingRooms.value = upcomingRooms;
    searchBarIsEmpty.value = true;
  }
}
