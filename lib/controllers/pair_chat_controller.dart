import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:resonate/utils/constants.dart';

class PairChatController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isAnonymous = true.obs;
  String languageIso = "en";

  RxBool isMicOn = false.obs;
  RxBool isLoudSpeakerOn = true.obs;
  String? requestDocId;
  String? activePairDocId;
  int? myRoomUserId;

  Client client = Client();
  late final Realtime realtime;
  late final Databases databases;
  late final RealtimeSubscription? subscription;

  @override
  void onInit() async {
    client.setEndpoint(appwriteEndpoint).setProject(appwriteProjectId).setSelfSigned(status: true);
    realtime = Realtime(client);
    databases = Databases(client);
    super.onInit();
  }

  void quickMatch() async {
    String uid = Get.find<AuthStateController>().uid!;

    // Open realtime stream to check whether the request is paired
    getRealtimeStream();

    // Add request to pair-request collection
    Document requestDoc = await databases.createDocument(
        databaseId: masterDatabaseId,
        collectionId: pairRequestCollectionId,
        documentId: ID.unique(),
        data: {"languageIso": languageIso, "isAnonymous": isAnonymous.value, "uid": uid});
    requestDocId = requestDoc.$id;

    // Go to pairing screen
    Get.toNamed(AppRoutes.pairing);
  }

  void getRealtimeStream() {
    String uid = Get.find<AuthStateController>().uid!;
    String channel = 'databases.$masterDatabaseId.collections.$activePairsCollectionId.documents';
    subscription = realtime.subscribe([channel]);
    subscription?.stream.listen((data) async {
      if (data.payload.isNotEmpty) {
        String uid1 = data.payload["uid1"];
        String uid2 = data.payload["uid2"];

        // If the request was served and the user was paired
        if (uid1 == uid || uid2 == uid) {
          log(data.toString());
          var docId = data.payload["\$id"].toString();
          String action = data.events.first.substring(channel.length + 1 + (docId.length) + 1);
          switch (action) {
            case 'create':
              {
                if (uid1 == uid) {
                  myRoomUserId = 1;
                } else {
                  myRoomUserId = 2;
                }
                activePairDocId = data.payload["\$id"];
                Get.toNamed(AppRoutes.pairChat);
                break;
              }
            case 'delete':{
              subscription?.close;
              Get.offAllNamed(AppRoutes.tabview);
            }
          }
        }
      }
    });
  }

  Future<void> cancelRequest() async{
    await databases.deleteDocument(databaseId: masterDatabaseId, collectionId: pairRequestCollectionId, documentId: requestDocId!);
    subscription?.close();
    Get.offAllNamed(AppRoutes.tabview);
  }

  void toggleMic() {
    isMicOn.value = !isMicOn.value;
  }

  void toggleLoudSpeaker(){
    isLoudSpeakerOn.value = !isLoudSpeakerOn.value;
  }

  Future<void> endChat() async{
    subscription?.close;
    await databases.deleteDocument(databaseId: masterDatabaseId, collectionId: activePairsCollectionId, documentId: activePairDocId!);
    Get.offAllNamed(AppRoutes.tabview);
  }
}
