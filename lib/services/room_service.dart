import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
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
    RoomsController roomsController = Get.find<RoomsController>();

    // Add participant to collection
    await roomsController.databases.createDocument(
        databaseId: masterDatabaseId,
        collectionId: participantsCollectionId,
        documentId: ID.unique().toString(),
        data: {
          "roomId": roomId,
          "uid": uid,
          "isAdmin": isAdmin,
          "isModerator": isAdmin,
          "isSpeaker": isAdmin,
          "isMicOn": false
        });

    if (!isAdmin){
      // Get present totalParticipants Attribute
      Document roomDoc = await roomsController.databases.getDocument(databaseId: masterDatabaseId, collectionId: roomsCollectionId, documentId: roomId);

      // Increment the totalParticipants Attribute
      await roomsController.databases.updateDocument(databaseId: masterDatabaseId, collectionId: roomsCollectionId, documentId: roomId,data: {
        "totalParticipants": roomDoc.data["totalParticipants"]+1
      });
    }

  }

  static Future<String> createRoom(
      {required String roomName, required String roomDescription, required List<String> roomTags, required String adminEmail, required String adminUid}) async {
    var response = await apiService.createRoom(roomName, roomDescription, adminEmail, roomTags);
    String appwriteRoomDocId = response.body["livekit_room"]["name"];
    String livekitToken = response.body["access_token"];
    String livekitSocketUrl = response.body["livekit_socket_url"];
    await addParticipantToAppwriteCollection(roomId: appwriteRoomDocId, uid: adminUid, isAdmin: true);
    //TODO: Use the received token and url to call joinLiveKitRoom method
    return appwriteRoomDocId;
  }

  static Future deleteRoom({required roomId}) async {
    //TODO: Use api service to delete the room (only admins)
  }

  static Future joinRoom({required roomId, required String userEmail, required String userId}) async {
    //TODO: Use api service to generate token and pass it to joinLiveKitRoom method, add participant to collection and increment total_participants
    var response = await apiService.joinRoom(roomId, userEmail);
    String livekitToken = response.body["access_token"];
    String livekitSocketUrl = response.body["livekit_socket_url"];
    await addParticipantToAppwriteCollection(roomId: roomId, uid: userId, isAdmin: false);
    //TODO: Use the received token and url to call joinLiveKitRoom method
  }

  static Future leaveRoom({required String roomId}) async {
    RoomsController roomsController = Get.find<RoomsController>();
    String userId = Get.find<AuthStateController>().uid!;

    // Get all documents with participant uid and roomid and delete them
    DocumentList participantDocsRef = await roomsController.databases.listDocuments(databaseId: masterDatabaseId, collectionId: participantsCollectionId, queries: [Query.equal("uid",[userId]), Query.equal('roomId', [roomId])]);
    for (var document in participantDocsRef.documents) {
      await roomsController.databases.deleteDocument(databaseId: masterDatabaseId, collectionId: participantsCollectionId, documentId: document.$id);
    }
    // Get present totalParticipants Attribute
    Document roomDoc = await roomsController.databases.getDocument(databaseId: masterDatabaseId, collectionId: roomsCollectionId, documentId: roomId);

    if (roomDoc.data["totalParticipants"]-participantDocsRef.documents.length==0){
      // Delete the room since there are no participants
      await roomsController.databases.deleteDocument(databaseId: masterDatabaseId, collectionId: roomsCollectionId, documentId: roomId);
    }
    else{
      // Decrease the totalParticipants Attribute
      await roomsController.databases.updateDocument(databaseId: masterDatabaseId, collectionId: roomsCollectionId, documentId: roomId,data: {
        "totalParticipants": roomDoc.data["totalParticipants"]-participantDocsRef.documents.length
      });
    }

  }
}
