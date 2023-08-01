import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/controllers/tabview_controller.dart';
import 'package:resonate/models/appwrite_room.dart';
import 'package:resonate/services/api/api_service.dart';
import 'package:resonate/services/room_service.dart';
import 'package:resonate/utils/enums/room_state.dart';

import '../utils/constants.dart';
import 'auth_state_controller.dart';

class RoomsController extends GetxController {
  RxBool isLoading = false.obs;
  Client client = Client();
  late final Databases databases;
  List<AppwriteRoom> rooms = [];

  @override
  void onInit() async {
    super.onInit();
    client.setEndpoint(appwriteEndpoint).setProject(appwriteProjectId).setSelfSigned(status: true);
    databases = Databases(client);
    await getRooms();
  }

  Future<void> getRooms() async {
    try {
      isLoading.value = true;
      String userUid = Get.find<AuthStateController>().uid!;

      // Get active rooms and add it to rooms list
      rooms = [];
      var roomsCollectionRef =
          await databases.listDocuments(databaseId: masterDatabaseId, collectionId: roomsCollectionId);

      for (var room in roomsCollectionRef.documents) {

        // Get three particpant data to use for memberAvatar widget
        var participantCollectionRef = await databases.listDocuments(databaseId: masterDatabaseId, collectionId: participantsCollectionId, queries:[Query.equal("roomId", room.data["\$id"]), Query.limit(3)]);
        List<String> memberAvatarUrls = [];
        for (var p in participantCollectionRef.documents){
          Document participantDoc = await databases.getDocument(databaseId: userDatabaseID, collectionId: usersCollectionID, documentId: p.data["uid"]);
          memberAvatarUrls.add(participantDoc.data["profileImageUrl"]);
        }

        // Create appwrite room object and add it to rooms list
        AppwriteRoom appwriteRoom = AppwriteRoom(id: room.data['\$id'], name: room.data["name"], description: room.data["description"], totalParticipants: room.data["totalParticipants"], tags: room.data["tags"], memberAvatarUrls: memberAvatarUrls, state: RoomState.live, isUserAdmin: room.data["adminUid"] == userUid);
        rooms.add(appwriteRoom);
      }
      update();
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> joinRoom({required AppwriteRoom room}) async {
    try{
      // Display Loading Dialog
      Get.dialog(
          Center(child: LoadingAnimationWidget.threeRotatingDots(color: Colors.amber, size: Get.pixelRatio*20),),
          barrierDismissible: false,
          name: "Loading Dialog"
      );

      // Get the token and livekit url and join livekit room
      AuthStateController authStateController = Get.find<AuthStateController>();
      String myDocId = await RoomService.joinRoom(roomId: room.id, userId: authStateController.uid!, isAdmin: room.isUserAdmin);
      room.myDocId = myDocId;

      // Close the loading dialog
      Get.back();

      // Open the Room Bottom Sheet to interact in the room
      Get.find<TabViewController>().openRoomSheet(room);
    }catch(e){
      log(e.toString());
      // Close the loading dialog
      Get.back();
    }
  }
}
