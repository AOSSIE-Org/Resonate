import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:resonate/controllers/rooms_controller.dart';
import 'package:resonate/services/api/api_service.dart';
import 'package:resonate/utils/constants.dart';

class RoomService {
  static ApiService apiService = ApiService();

  Future<void> joinLiveKitRoom(String livekitUri, String roomToken) async {
    //TODO: Use Livekit SDK to intialize a room object
  }

  static Future<void> addParticipantToAppwriteCollection(
      {required String roomId, required String uid, required bool isAdmin}) async {
    //TODO: use common appwrite controller to access database (after refactoring)
    RoomsController roomsController = Get.find<RoomsController>();
    await roomsController.databases.createDocument(
        databaseId: masterDatabaseId,
        collectionId: participantsCollectionId,
        documentId: ID.unique().toString(),
        data: {
          "roomId": roomId,
          "uid": uid,
          "isAdmin": isAdmin,
          "isModerator": true,
          "isSpeaker": true,
          "isMicOn": false
        });
  }

  static Future createRoom(
      {required String roomName, required String roomDescription, required List<String> roomTags, required String adminEmail, required String adminUid}) async {
    var response = await apiService.createRoom(roomName, roomDescription, "test@test.com", roomTags);
    String appwriteRoomDocId = response.body["livekit_room"]["name"];
    String livekitToken = response.body["access_token"];
    await addParticipantToAppwriteCollection(roomId: appwriteRoomDocId, uid: adminUid, isAdmin: true);
    //TODO: Use the received token to call joinLiveKitRoom method
  }

  static Future deleteRoom({required roomName}) async {
    //TODO: Use api service to delete the room (only admins)
  }

  static Future joinRoom({required roomName, required description}) async {
    //TODO: Use api service to generate token and pass it to joinLiveKitRoom method
  }

  static Future leaveRoom({required roomName}) async {
    //TODO: delete the user's document from participants collection and decrement total_participants
  }
}
