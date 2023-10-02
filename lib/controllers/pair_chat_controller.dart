import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:get/get.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:resonate/services/appwrite_service.dart';
import 'package:resonate/services/room_service.dart';
import 'package:resonate/utils/constants.dart';

import 'livekit_controller.dart';

class PairChatController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isAnonymous = true.obs;
  String languageIso = "en";

  RxBool isMicOn = false.obs;
  RxBool isLoudSpeakerOn = true.obs;
  String? requestDocId;
  String? activePairDocId;
  int? myRoomUserId;

  String? pairUsername;
  String? pairProfileImageUrl;

  Client client = AppwriteService.getClient();
  final Realtime realtime = AppwriteService.getRealtime();
  final Databases databases = AppwriteService.getDatabases();
  late final RealtimeSubscription? subscription;

  void quickMatch() async {
    String uid = Get.find<AuthStateController>().uid!;
    String userName = Get.find<AuthStateController>().userName!;

    // Open realtime stream to check whether the request is paired
    getRealtimeStream();

    Map<String, dynamic> requestData = {"languageIso": languageIso, "isAnonymous": isAnonymous.value, "uid": uid};
    requestData.addIf(!isAnonymous.value, "userName", userName);

    // Add request to pair-request collection
    Document requestDoc = await databases.createDocument(
        databaseId: masterDatabaseId,
        collectionId: pairRequestCollectionId,
        documentId: ID.unique(),
        data: requestData);
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
                  pairUsername = data.payload["userName2"];
                  Document participantDoc = await databases.getDocument(
                      databaseId: userDatabaseID, collectionId: usersCollectionID, documentId: data.payload["uid2"]);
                  pairProfileImageUrl = participantDoc.data["profileImageUrl"];
                } else {
                  myRoomUserId = 2;
                  pairUsername = data.payload["userName1"];
                  Document participantDoc = await databases.getDocument(
                      databaseId: userDatabaseID, collectionId: usersCollectionID, documentId: data.payload["uid1"]);
                  pairProfileImageUrl = participantDoc.data["profileImageUrl"];
                }
                activePairDocId = data.payload["\$id"];
                await joinPairChat(activePairDocId, uid);
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

  Future<void> joinPairChat(roomId, userId) async{
    await RoomService.joinLivekitPairChat(roomId: roomId, userId: userId);
    Get.toNamed(AppRoutes.pairChat);
  }

  Future<void> cancelRequest() async{
    await databases.deleteDocument(databaseId: masterDatabaseId, collectionId: pairRequestCollectionId, documentId: requestDocId!);
    subscription?.close();
    Get.offAllNamed(AppRoutes.tabview);
  }

  void toggleMic() async {
    isMicOn.value = !isMicOn.value;
    await Get.find<LiveKitController>().liveKitRoom.localParticipant?.setMicrophoneEnabled(isMicOn.value);
  }

  void toggleLoudSpeaker(){
    isLoudSpeakerOn.value = !isLoudSpeakerOn.value;
    Hardware.instance.setSpeakerphoneOn(isLoudSpeakerOn.value);
  }

  Future<void> endChat() async{
    subscription?.close;
    await databases.deleteDocument(databaseId: masterDatabaseId, collectionId: activePairsCollectionId, documentId: activePairDocId!);
    await Get.delete<LiveKitController>(force: true);
    Get.offAllNamed(AppRoutes.tabview);
  }
}
