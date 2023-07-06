import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/tabview_controller.dart';
import 'package:resonate/services/api/api_service.dart';
import 'package:resonate/services/room_service.dart';

import '../utils/constants.dart';
import 'auth_state_controller.dart';

class RoomsController extends GetxController {
  RxBool isLoading = false.obs;
  Client client = Client();
  late final Databases databases;
  List<Map<String, dynamic>> rooms = [];

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
      rooms = [];
      var roomsCollectionRef =
          await databases.listDocuments(databaseId: masterDatabaseId, collectionId: roomsCollectionId);
      for (var room in roomsCollectionRef.documents) {
        rooms.add(room.data);
      }
      update();
      return;
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> joinRoom({required String roomId}) async {
    // Get the token and livekit url and join livekit room
    AuthStateController authStateController = Get.find<AuthStateController>();
    await RoomService.joinRoom(roomId: roomId, userEmail: authStateController.email!, userId: authStateController.uid!);

    // Open the Room Bottom Sheet to interact in the room
    Get.find<TabViewController>().openRoomSheet();
  }
}
