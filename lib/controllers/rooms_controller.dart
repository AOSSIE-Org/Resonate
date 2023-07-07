import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:get/get.dart';
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
        AppwriteRoom appwriteRoom = AppwriteRoom(id: room.data['\$id'], name: room.data["name"], description: room.data["description"], totalParticipants: room.data["totalParticipants"], tags: room.data["tags"], memberAvatarUrls: memberAvatarUrls, state: RoomState.live);
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
    // Get the token and livekit url and join livekit room
    AuthStateController authStateController = Get.find<AuthStateController>();
    await RoomService.joinRoom(roomId: room.id, userEmail: authStateController.email!, userId: authStateController.uid!);

    // Open the Room Bottom Sheet to interact in the room
    Get.find<TabViewController>().openRoomSheet(room);
  }
}
