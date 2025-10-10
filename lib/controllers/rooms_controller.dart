import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:meilisearch/meilisearch.dart';
import 'package:resonate/controllers/tabview_controller.dart';
import 'package:resonate/models/appwrite_room.dart';
import 'package:resonate/models/appwrite_upcomming_room.dart';
import 'package:resonate/services/appwrite_service.dart';
import 'package:resonate/services/room_service.dart';
import 'package:resonate/themes/theme_controller.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/utils/enums/room_state.dart';
import 'package:resonate/views/widgets/snackbar.dart';

import '../utils/constants.dart';
import 'auth_state_controller.dart';

class RoomsController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isOnActive = false.obs;
  Client client = AppwriteService.getClient();
  final Databases databases = AppwriteService.getDatabases();
  RxList<AppwriteRoom> rooms = <AppwriteRoom>[].obs;
  final ThemeController themeController = Get.find<ThemeController>();
  RxBool isSearching = false.obs;
  RxBool searchBarIsEmpty = true.obs;
  RxList<AppwriteRoom> filteredRooms = <AppwriteRoom>[].obs;
  RxList<AppwriteUpcommingRoom> filteredUpcomingRooms =
      <AppwriteUpcommingRoom>[].obs;
  final MeiliSearchClient meilisearchClient = MeiliSearchClient(
    meilisearchEndpoint,
    meilisearchApiKey,
  );
  late final MeiliSearchIndex roomsIndex;
  late final MeiliSearchIndex upcomingRoomsIndex;

  @override
  void onInit() async {
    super.onInit();
    roomsIndex = meilisearchClient.index('rooms');
    upcomingRoomsIndex = meilisearchClient.index('upcoming_rooms');
    await getRooms();
    filteredRooms.value = rooms;
  }

  Future<AppwriteRoom> createRoomObject(Document room, String userUid) async {
    // Get three particpant data to use for memberAvatar widget
    var participantCollectionRef = await databases.listDocuments(
      databaseId: masterDatabaseId,
      collectionId: participantsCollectionId,
      queries: [Query.equal("roomId", room.data["\$id"]), Query.limit(3)],
    );
    List<String> memberAvatarUrls = [];
    for (var p in participantCollectionRef.documents) {
      Document participantDoc = await databases.getDocument(
        databaseId: userDatabaseID,
        collectionId: usersCollectionID,
        documentId: p.data["uid"],
      );
      memberAvatarUrls.add(participantDoc.data["profileImageUrl"]);
    }

    // Create appwrite room object and add it to rooms list
    AppwriteRoom appwriteRoom = AppwriteRoom(
      id: room.data['\$id'],
      name: room.data["name"],
      description: room.data["description"],
      totalParticipants: room.data["totalParticipants"],
      tags: room.data["tags"],
      memberAvatarUrls: memberAvatarUrls,
      state: RoomState.live,
      isUserAdmin: room.data["adminUid"] == userUid,
      reportedUsers: List<String>.from(room.data["reportedUsers"] ?? []),
    );

    return appwriteRoom;
  }

  Future<void> getRooms() async {
    try {
      isLoading.value = true;
      String userUid = Get.find<AuthStateController>().uid!;

      // Get active rooms and add it to rooms list
      rooms.value = [];
      var roomsCollectionRef = await databases.listDocuments(
        databaseId: masterDatabaseId,
        collectionId: roomsCollectionId,
      );

      for (var room in roomsCollectionRef.documents) {
        AppwriteRoom appwriteRoom = await createRoomObject(room, userUid);
        if (!appwriteRoom.reportedUsers.contains(userUid)) {
          rooms.add(appwriteRoom);
        }
      }
      update();
      updateFilteredRooms();
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future getRoomById(String roomId) async {
    try {
      Document room = await databases.getDocument(
        databaseId: masterDatabaseId,
        collectionId: roomsCollectionId,
        documentId: roomId,
      );
      String userUid = Get.find<AuthStateController>().uid!;

      AppwriteRoom appwriteRoom = await createRoomObject(room, userUid);
      return appwriteRoom;
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> joinRoom({
    required AppwriteRoom room,
    required BuildContext context,
  }) async {
    try {
      Get.dialog(
        Center(
          child: LoadingAnimationWidget.threeRotatingDots(
            color: Theme.of(context).primaryColor,
            size: Get.pixelRatio * 20,
          ),
        ),
        barrierDismissible: false,
        name: AppLocalizations.of(Get.context!)!.loadingDialog,
      );

      // Get the token and livekit url and join livekit room
      AuthStateController authStateController = Get.find<AuthStateController>();
      String myDocId = await RoomService.joinRoom(
        roomId: room.id,
        userId: authStateController.uid!,
        isAdmin: room.isUserAdmin,
      );
      room.myDocId = myDocId;

      // Close the loading dialog
      Get.back();
      // Open the Room Bottom Sheet to interact in the room
      Get.find<TabViewController>().openRoomSheet(room);
    } catch (e) {
      log(e.toString());
      getRooms();
      update();
      // Close the loading dialog
      Get.back();
    }
  }

  Future<void> searchRooms(
    String query, {
    bool isLiveRooms = true,
    List<AppwriteUpcommingRoom>? upcomingRooms,
  }) async {
    if (query.isEmpty) {
      if (isLiveRooms) {
        filteredRooms.value = rooms;
        searchBarIsEmpty.value = true;
      } else {
        filteredUpcomingRooms.value = upcomingRooms ?? [];
      }
      return;
    }
    if (isLiveRooms) {
      isSearching.value = true;
      searchBarIsEmpty.value = false;
    }
    try {
      if (isUsingMeilisearch) {
        final indexToUse = isLiveRooms ? roomsIndex : upcomingRoomsIndex;
        final meilisearchResult = await indexToUse.search(
          query,
          SearchQuery(
            attributesToHighlight: ['name'],
            attributesToSearchOn: ['name'],
          ),
        );
        if (isLiveRooms) {
          filteredRooms.value = await convertMeilisearchResults(
            meilisearchResult.hits,
            isLiveRooms: true,
          );
        } else {
          filteredUpcomingRooms.value = await convertMeilisearchResults(
            meilisearchResult.hits,
            isLiveRooms: false,
            originalUpcomingRooms: upcomingRooms ?? [],
          );
        }
      } else {
        if (isLiveRooms) {
          final searchResults = rooms.where((room) {
            return room.name.toLowerCase().contains(query.toLowerCase());
          }).toList();
          filteredRooms.value = searchResults;
        } else {
          final filtered = (upcomingRooms ?? []).where((room) {
            return room.name.toLowerCase().contains(query.toLowerCase());
          }).toList();
          filteredUpcomingRooms.value = filtered;
        }
      }
    } catch (e) {
      final roomType = isLiveRooms ? 'rooms' : 'upcoming rooms';
      log('Error searching $roomType: $e');
      if (isLiveRooms) {
        filteredRooms.value = [];
      } else {
        filteredUpcomingRooms.value = [];
      }
      final context = Get.context;
      if (context != null) {
        final localizations = AppLocalizations.of(context)!;
        customSnackbar(
          localizations.searchError,
          isLiveRooms
              ? localizations.searchRoomsError
              : localizations.searchUpcomingRoomsError,
          LogType.error,
        );
      }
    } finally {
      if (isLiveRooms) {
        isSearching.value = false;
      }
    }
  }

  Future<dynamic> convertMeilisearchResults(
    List<Map<String, dynamic>> meilisearchHits, {
    required bool isLiveRooms,
    List<AppwriteUpcommingRoom>? originalUpcomingRooms,
  }) async {
    if (isLiveRooms) {
      //live rooms
      return await Future.wait(
        meilisearchHits.map((hit) async {
          String userUid = Get.find<AuthStateController>().uid!;
          var participantCollectionRef = await databases.listDocuments(
            databaseId: masterDatabaseId,
            collectionId: participantsCollectionId,
            queries: [Query.equal('roomId', hit['\$id']), Query.limit(3)],
          );
          List<String> memberAvatarUrls = [];
          for (var p in participantCollectionRef.documents) {
            Document participantDoc = await databases.getDocument(
              databaseId: userDatabaseID,
              collectionId: usersCollectionID,
              documentId: p.data['uid'],
            );
            memberAvatarUrls.add(participantDoc.data['profileImageUrl']);
          }
          return AppwriteRoom(
            id: hit['\$id'],
            name: hit['name'],
            description: hit['description'],
            totalParticipants: hit['totalParticipants'],
            tags: List<String>.from(hit['tags'] ?? []),
            memberAvatarUrls: memberAvatarUrls,
            state: RoomState.live,
            isUserAdmin: hit['adminUid'] == userUid,
            reportedUsers: List<String>.from(hit['reportedUsers'] ?? []),
          );
        }).toList(),
      );
    } else {
      //upcoming rooms
      return meilisearchHits.map((hit) {
        final originalRoom = (originalUpcomingRooms ?? []).firstWhere(
          (room) => room.id == hit['\$id'],
          orElse: () => AppwriteUpcommingRoom(
            id: hit['\$id'] ?? '',
            name: hit['name'] ?? 'Unknown',
            isTime: hit['isTime'] ?? false,
            scheduledDateTime:
                DateTime.tryParse(hit['scheduledDateTime'] ?? '') ??
                DateTime.now(),
            totalSubscriberCount: 0,
            tags: List<String>.from(hit['tags'] ?? []),
            subscribersAvatarUrls: [],
            userIsCreator: false,
            description: hit['description'] ?? '',
            hasUserSubscribed: false,
          ),
        );
        return originalRoom;
      }).toList();
    }
  }

  void clearSearch() {
    filteredRooms.value = rooms;
    searchBarIsEmpty.value = true;
  }

  void updateFilteredRooms() {
    if (searchBarIsEmpty.value) {
      filteredRooms.value = rooms;
    }
  }
}
