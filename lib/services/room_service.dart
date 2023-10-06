
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/controllers/livekit_controller.dart';
import 'package:resonate/controllers/rooms_controller.dart';
import 'package:resonate/services/api_service.dart';
import 'package:resonate/utils/constants.dart';

class RoomService {
  static ApiService apiService = ApiService();

  static Future<void> joinLiveKitRoom(String livekitUri, String roomToken) async {
    Get.put(LiveKitController(liveKitUri: livekitUri, roomToken: roomToken), permanent: true);
  }

  static Future<String> addParticipantToAppwriteCollection(
      {required String roomId, required String uid, required bool isAdmin}) async {
    RoomsController roomsController = Get.find<RoomsController>();

    // Get all documents with participant uid and roomid and delete them before adding the participant again
    DocumentList participantDocsRef = await roomsController.databases
        .listDocuments(databaseId: masterDatabaseId, collectionId: participantsCollectionId, queries: [
      Query.equal("uid", [uid]),
      Query.equal('roomId', [roomId])
    ]);
    for (var document in participantDocsRef.documents) {
      await roomsController.databases.deleteDocument(
          databaseId: masterDatabaseId, collectionId: participantsCollectionId, documentId: document.$id);
    }

    // Add participant to collection
    Document participantDoc = await roomsController.databases.createDocument(
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

    if (!isAdmin) {
      // Get present totalParticipants Attribute
      Document roomDoc = await roomsController.databases
          .getDocument(databaseId: masterDatabaseId, collectionId: roomsCollectionId, documentId: roomId);

      // Increment the totalParticipants Attribute
      await roomsController.databases.updateDocument(
          databaseId: masterDatabaseId,
          collectionId: roomsCollectionId,
          documentId: roomId,
          data: {"totalParticipants": roomDoc.data["totalParticipants"] - participantDocsRef.documents.length  + 1});
    }

    return participantDoc.$id;
  }

  static Future<List<String>> createRoom(
      {required String roomName,
      required String roomDescription,
      required List<String> roomTags,
      required String adminUid}) async {
    var response = await apiService.createRoom(roomName, roomDescription, adminUid, roomTags);
    String appwriteRoomDocId = response["livekit_room"]["name"];
    String livekitToken = response["access_token"];
    String livekitSocketUrl = response["livekit_socket_url"];

    // Store Livekit Url and Token in Secure Storage
    const storage = FlutterSecureStorage();
    await storage.write(key: "createdRoomAdminToken", value: livekitToken);
    await storage.write(key: "createdRoomLivekitUrl", value: livekitSocketUrl);

    String myDocId = await addParticipantToAppwriteCollection(roomId: appwriteRoomDocId, uid: adminUid, isAdmin: true);
    await joinLiveKitRoom(livekitSocketUrl, livekitToken);

    return [appwriteRoomDocId, myDocId];
  }

  static Future deleteRoom({required roomId}) async {
    RoomsController roomsController = Get.find<RoomsController>();
    const storage = FlutterSecureStorage();

    // Delete room on livekit and roomdoc on appwrite
    String? livekitToken = await storage.read(key: "createdRoomAdminToken");
    await apiService.deleteRoom(roomId, livekitToken!);

    // Get all participant documents and delete them
    DocumentList participantDocsRef = await roomsController.databases
        .listDocuments(databaseId: masterDatabaseId, collectionId: participantsCollectionId, queries: [
      Query.equal('roomId', [roomId])
    ]);
    for (var document in participantDocsRef.documents) {
      await roomsController.databases.deleteDocument(
          databaseId: masterDatabaseId, collectionId: participantsCollectionId, documentId: document.$id);
    }
  }

  static Future<String> joinRoom({required roomId, required String userId, required bool isAdmin}) async {
    var response = await apiService.joinRoom(roomId, userId);
    String livekitToken = response["access_token"];
    String livekitSocketUrl = response["livekit_socket_url"];
    String myDocId = await addParticipantToAppwriteCollection(roomId: roomId, uid: userId, isAdmin: isAdmin);
    await joinLiveKitRoom(livekitSocketUrl, livekitToken);
    return myDocId;
  }

  static Future<bool> leaveRoom({required String roomId}) async {
    RoomsController roomsController = Get.find<RoomsController>();
    String userId = Get.find<AuthStateController>().uid!;

    Document roomDoc = await roomsController.databases
        .getDocument(databaseId: masterDatabaseId, collectionId: roomsCollectionId, documentId: roomId);

    // Get all documents with participant uid and roomid and delete them
    DocumentList participantDocsRef = await roomsController.databases
        .listDocuments(databaseId: masterDatabaseId, collectionId: participantsCollectionId, queries: [
      Query.equal("uid", [userId]),
      Query.equal('roomId', [roomId])
    ]);
    for (var document in participantDocsRef.documents) {
      await roomsController.databases.deleteDocument(
          databaseId: masterDatabaseId, collectionId: participantsCollectionId, documentId: document.$id);
    }

    // Get present totalParticipants Attribute
    if (roomDoc.data["totalParticipants"] - participantDocsRef.documents.length == 0) {
      // Delete the room since there are no participants
      await roomsController.databases
          .deleteDocument(databaseId: masterDatabaseId, collectionId: roomsCollectionId, documentId: roomId);
    } else {
      // Decrease the totalParticipants Attribute
      await roomsController.databases.updateDocument(
          databaseId: masterDatabaseId,
          collectionId: roomsCollectionId,
          documentId: roomId,
          data: {"totalParticipants": roomDoc.data["totalParticipants"] - participantDocsRef.documents.length});
    }
    return true;
  }

  static Future<void> joinLivekitPairChat({required roomId, required String userId}) async {
    var response = await apiService.joinRoom(roomId, userId);
    String livekitToken = response["access_token"];
    String livekitSocketUrl = response["livekit_socket_url"];
    await joinLiveKitRoom(livekitSocketUrl, livekitToken);
  }
}
