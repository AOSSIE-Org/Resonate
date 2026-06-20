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

  static Future<void> joinLiveKitRoom(
    String livekitUri,
    String roomToken, {
    bool isLiveChapter = false,
  }) async {
    Get.put(
      LiveKitController(
        liveKitUri: livekitUri,
        roomToken: roomToken,
        isLiveChapter: isLiveChapter,
      ),
      permanent: true,
    );
  }

  static Future<String> addParticipantToAppwriteCollection({
    required String roomId,
    required String uid,
    required bool isAdmin,
  }) async {
    RoomsController roomsController = Get.find<RoomsController>();

    // Get all documents with participant uid and roomid and delete them before adding the participant again
    RowList participantDocsRef = await roomsController.tablesDB.listRows(
      databaseId: masterDatabaseId,
      tableId: participantsTableId,
      queries: [
        Query.equal("uid", [uid]),
        Query.equal('roomId', [roomId]),
      ],
    );
    for (var document in participantDocsRef.rows) {
      await roomsController.tablesDB.deleteRow(
        databaseId: masterDatabaseId,
        tableId: participantsTableId,
        rowId: document.$id,
      );
    }
    // Add participant to collection
    Row participantDoc = await roomsController.tablesDB.createRow(
      databaseId: masterDatabaseId,
      tableId: participantsTableId,
      rowId: ID.unique().toString(),
      data: {
        "roomId": roomId,
        "uid": uid,
        "isAdmin": isAdmin,
        "isModerator": isAdmin,
        "isSpeaker": isAdmin,
        "isMicOn": false,
      },
    );
    if (!isAdmin) {
      // Get present totalParticipants Attribute
      Row roomDoc = await roomsController.tablesDB.getRow(
        databaseId: masterDatabaseId,
        tableId: roomsTableId,
        rowId: roomId,
      );

      // Increment the totalParticipants Attribute
      int newParticipantCount =
          roomDoc.data["totalParticipants"] -
          participantDocsRef.rows.length +
          1;
      await roomsController.tablesDB.updateRow(
        databaseId: masterDatabaseId,
        tableId: roomsTableId,
        rowId: roomId,
        data: {"totalParticipants": newParticipantCount},
      );
    }

    return participantDoc.$id;
  }

  static Future<List<String>> createRoom({
    required String roomName,
    required String roomDescription,
    required List<String> roomTags,
    required String adminUid,
  }) async {
    var response = await apiService.createRoom(
      roomName,
      roomDescription,
      adminUid,
      roomTags,
    );
    String appwriteRoomDocId = response["livekit_room"]["name"];
    String livekitToken = response["access_token"];
    String livekitSocketUrl =
        response["livekit_socket_url"] == "wss://host.docker.internal:7880"
        ? localhostLivekitEndpoint
        : response["livekit_socket_url"];

    // Store Livekit Url and Token in Secure Storage
    try {
      const storage = FlutterSecureStorage(aOptions: androidOptions);
      await storage.write(key: "createdRoomAdminToken", value: livekitToken);
      await storage.write(
        key: "createdRoomLivekitUrl",
        value: livekitSocketUrl,
      );
    } catch (e) {
      Get.snackbar("Error", "Failed to save room token: $e");
    }

    String myDocId = await addParticipantToAppwriteCollection(
      roomId: appwriteRoomDocId,
      uid: adminUid,
      isAdmin: true,
    );
    await joinLiveKitRoom(livekitSocketUrl, livekitToken);

    return [appwriteRoomDocId, myDocId];
  }

  static Future<List<String>> createLiveChapterRoom({
    required String appwriteRoomId,
    required String adminUid,
  }) async {
    var response = await apiService.createLiveChapterRoom(
      appwriteRoomId,
      adminUid,
    );
    String appwriteRoomDocId = response["livekit_room"]["name"];
    String livekitToken = response["access_token"];
    String livekitSocketUrl =
        response["livekit_socket_url"] == "wss://host.docker.internal:7880"
        ? localhostLivekitEndpoint
        : response["livekit_socket_url"];

    // Store Livekit Url and Token in Secure Storage
    try {
      const storage = FlutterSecureStorage(aOptions: androidOptions);
      await storage.write(key: "createdRoomAdminToken", value: livekitToken);
      await storage.write(
        key: "createdRoomLivekitUrl",
        value: livekitSocketUrl,
      );
    } catch (e) {
      Get.snackbar("Error", "Failed to save room token: $e");
    }

    await joinLiveKitRoom(livekitSocketUrl, livekitToken, isLiveChapter: true);

    return [appwriteRoomDocId];
  }

  static Future<void> joinLiveChapterRoom({
    required roomId,
    required String userId,
  }) async {
    var response = await apiService.joinRoom(roomId, userId);
    String livekitToken = response["access_token"];
    String livekitSocketUrl =
        response["livekit_socket_url"] == "wss://host.docker.internal:7880"
        ? localhostLivekitEndpoint
        : response["livekit_socket_url"];

    await joinLiveKitRoom(livekitSocketUrl, livekitToken, isLiveChapter: true);
  }

  static Future deleteLiveChapterRoom({required roomId}) async {
    try {
      const storage = FlutterSecureStorage(aOptions: androidOptions);

      // Delete room on livekit and roomdoc on appwrite
      String? livekitToken = await storage.read(key: "createdRoomAdminToken");
      if (livekitToken != null) {
        await apiService.deleteLiveChapterRoom(roomId, livekitToken);
      }
    } catch (e) {
      print("Error deleting live chapter room: $e");
    }
  }

  static Future deleteRoom({required roomId}) async {
    RoomsController roomsController = Get.find<RoomsController>();
    try {
      const storage = FlutterSecureStorage(aOptions: androidOptions);

      // Delete room on livekit and roomdoc on appwrite
      String? livekitToken = await storage.read(key: "createdRoomAdminToken");
      if (livekitToken != null) {
        await apiService.deleteRoom(roomId, livekitToken);
      }
    } catch (e) {
      print("Error deleting room: $e");
    }

    // Get all participant documents and delete them
    RowList participantDocsRef = await roomsController.tablesDB.listRows(
      databaseId: masterDatabaseId,
      tableId: participantsTableId,
      queries: [
        Query.equal('roomId', [roomId]),
      ],
    );

    for (var document in participantDocsRef.rows) {
      await roomsController.tablesDB.deleteRow(
        databaseId: masterDatabaseId,
        tableId: participantsTableId,
        rowId: document.$id,
      );
    }
  }

  static Future<String> joinRoom({
    required roomId,
    required String userId,
    required bool isAdmin,
  }) async {
    var response = await apiService.joinRoom(roomId, userId);
    String livekitToken = response["access_token"];
    String livekitSocketUrl =
        response["livekit_socket_url"] == "wss://host.docker.internal:7880"
        ? localhostLivekitEndpoint
        : response["livekit_socket_url"];

    String myDocId = await addParticipantToAppwriteCollection(
      roomId: roomId,
      uid: userId,
      isAdmin: isAdmin,
    );
    await joinLiveKitRoom(livekitSocketUrl, livekitToken);
    return myDocId;
  }

  static Future<bool> leaveRoom({required String roomId}) async {
    RoomsController roomsController = Get.find<RoomsController>();
    String userId = Get.find<AuthStateController>().uid!;

    Row roomDoc = await roomsController.tablesDB.getRow(
      databaseId: masterDatabaseId,
      tableId: roomsTableId,
      rowId: roomId,
    );

    // Get all documents with participant uid and roomid and delete them
    RowList participantDocsRef = await roomsController.tablesDB.listRows(
      databaseId: masterDatabaseId,
      tableId: participantsTableId,
      queries: [
        Query.equal("uid", [userId]),
        Query.equal('roomId', [roomId]),
      ],
    );
    for (var document in participantDocsRef.rows) {
      await roomsController.tablesDB.deleteRow(
        databaseId: masterDatabaseId,
        tableId: participantsTableId,
        rowId: document.$id,
      );
    }

    // Get present totalParticipants Attribute
    if (roomDoc.data["totalParticipants"] - participantDocsRef.rows.length ==
        0) {
      // Delete the room since there are no participants
      await roomsController.tablesDB.deleteRow(
        databaseId: masterDatabaseId,
        tableId: roomsTableId,
        rowId: roomId,
      );
    } else {
      // Decrease the totalParticipants Attribute
      await roomsController.tablesDB.updateRow(
        databaseId: masterDatabaseId,
        tableId: roomsTableId,
        rowId: roomId,
        data: {
          "totalParticipants":
              roomDoc.data["totalParticipants"] -
              participantDocsRef.rows.length,
        },
      );
    }
    return true;
  }

  static Future<void> joinLivekitPairChat({
    required roomId,
    required String userId,
  }) async {
    var response = await apiService.joinRoom(roomId, userId);
    String livekitToken = response["access_token"];
    String livekitSocketUrl =
        response["livekit_socket_url"] == "wss://host.docker.internal:7880"
        ? localhostLivekitEndpoint
        : response["livekit_socket_url"];

    await joinLiveKitRoom(livekitSocketUrl, livekitToken);
  }
}
