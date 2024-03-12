//import required packages
import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/controllers/tabview_controller.dart';
import 'package:resonate/models/appwrite_room.dart';
import 'package:resonate/services/appwrite_service.dart';
import 'package:resonate/services/room_service.dart';
import 'package:resonate/utils/enums/room_state.dart';

import '../utils/constants.dart';
import 'auth_state_controller.dart';

class RoomsController extends GetxController {
  RxBool isLoading =
      false.obs; //reactive variable indicating the state of RoomsController
  //create an instance of Client class using getClient() method of AppwriteService class provided by appwrite package
  //this allows app to communicate with AppWrite servers
  Client client = AppwriteService.getClient();
  //fetch the database from AppWrite server using getDatabases() method of AppwriteService class
  final Databases databases = AppwriteService.getDatabases();
  //create a list of AppWriteRoom called rooms
  //AppWriteRoom is defined in lib/models/appwrite_room.dart
  //AppWriteRoom class stores information about room like id,name, description etc.
  List<AppwriteRoom> rooms = [];

  @override
  void onInit() async {
    super.onInit();
    await getRooms();
  }

  //createRoomObject is a method that is used to create room and update the database
  Future<AppwriteRoom> createRoomObject(Document room, String userUid) async {
    // Get three particpant data to use for memberAvatar widget
    var participantCollectionRef = await databases.listDocuments(
        //constants defined in //lib/utils/constants.dart
        databaseId: masterDatabaseId,
        collectionId: participantsCollectionId,
        //use queries check if the document has "roomId" value of key of db is equal to the value of key "id" of Document room
        //if the query is matched the documents from db will be stored in participantCollectionRef
        queries: [Query.equal("roomId", room.data["\$id"]), Query.limit(3)]);
    List<String> memberAvatarUrls =
        []; //List of string storing the links to avatar images of members of room
    for (var p in participantCollectionRef.documents) {
      //get document of members based on "uid"
      Document participantDoc = await databases.getDocument(
          databaseId: userDatabaseID,
          collectionId: usersCollectionID,
          documentId: p.data["uid"]);
      //add link to members avatar image to the document
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
        isUserAdmin: room.data["adminUid"] == userUid);

    return appwriteRoom;
  }

  //getRooms() method is used to get the list of available rooms
  Future<void> getRooms() async {
    try {
      isLoading.value = true;
      String userUid = Get.find<AuthStateController>().uid!;

      // Get active rooms and add it to rooms list
      rooms = [];
      var roomsCollectionRef = await databases.listDocuments(
          databaseId: masterDatabaseId, collectionId: roomsCollectionId);

      for (var room in roomsCollectionRef.documents) {
        AppwriteRoom appwriteRoom = await createRoomObject(room, userUid);
        rooms.add(appwriteRoom);
      }
      update();
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  //getRoomById function is used to find the room based on roomId
  Future getRoomById(String roomId) async {
    try {
      //use getDocument() method of appwrite package to access document from db
      Document room = await databases.getDocument(
          databaseId: masterDatabaseId,
          collectionId: roomsCollectionId,
          documentId: roomId);
      String userUid = Get.find<AuthStateController>()
          .uid!; //find the user id from AuthStateController
      //call createRoomObject() method to create a AppwriteRoom based on Document room and userId
      AppwriteRoom appwriteRoom = await createRoomObject(room, userUid);
      return appwriteRoom;
    } catch (e) {
      log(e.toString());
    }
  }

  //joinRoom() method allows users to join room
  Future<void> joinRoom({required AppwriteRoom room}) async {
    try {
      // Display Loading Dialog
      Get.dialog(
          Center(
            child: LoadingAnimationWidget.threeRotatingDots(
                color: Colors.amber, size: Get.pixelRatio * 20),
          ),
          barrierDismissible: false,
          name: "Loading Dialog");

      // Get the token and livekit url and join livekit room
      //joinRoom() method of RoomService class defined in lib/services/room_service.dart
      //allows users to join room
      AuthStateController authStateController = Get.find<AuthStateController>();
      String myDocId = await RoomService.joinRoom(
          roomId: room.id,
          userId: authStateController.uid!,
          isAdmin: room.isUserAdmin);
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
}
