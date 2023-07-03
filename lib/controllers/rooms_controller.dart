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
    client.setEndpoint(APPWRITE_ENDPOINT).setProject(APPWRITE_PROJECT_ID).setSelfSigned(status: true);
    databases = Databases(client);
    await getRooms();
  }

  Future<void> getRooms() async {
    try {
      isLoading.value = true;
      var roomDCollectionRef = await databases.listDocuments(databaseId: "master", collectionId: "rooms");
      for (var room in roomDCollectionRef.documents) {
        rooms.add(room.data);
      }
      update();
      print(rooms);
      return;
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
