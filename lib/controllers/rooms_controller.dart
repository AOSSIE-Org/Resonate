import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:get/get.dart';

import '../utils/constants.dart';

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
      var roomsCollectionRef = await databases.listDocuments(databaseId: masterDatabaseId, collectionId: roomsCollectionId);
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
}
