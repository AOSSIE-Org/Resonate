//import required packages
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

//PairChatController provides realtime chat feature when user 
class PairChatController extends GetxController {
  RxBool isLoading = false.obs; //Reactive boolean to check state of PairChatController
  RxBool isAnonymous = true.obs; //Reactive boolean check weather user is logged in anonymously
  String languageIso = "en"; //use english as primary chat language

  RxBool isMicOn = false.obs; //Reactive boolean to check mic status
  RxBool isLoudSpeakerOn = true.obs;//Reactive boolean to check loud speaker status
  String? requestDocId; //document id associated with user
  String? activePairDocId; //pair chat doc id associated with the user
  int? myRoomUserId; //user if of the user who has joined the room

  String? pairUsername; //username of the user for pair chat
  String? pairProfileImageUrl;//url to profile image of the user for pair chat

  //connect to appwrite servers
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
  //join chat using joinLivekitPairChat method of livekit_client package
  Future<void> joinPairChat(roomId, userId) async{
    await RoomService.joinLivekitPairChat(roomId: roomId, userId: userId);
    Get.toNamed(AppRoutes.pairChat);
  }

  //cancleRequest() method is used to
  //delete the document from database and naviagte to TabView
  Future<void> cancelRequest() async{
    await databases.deleteDocument(databaseId: masterDatabaseId, collectionId: pairRequestCollectionId, documentId: requestDocId!);
    subscription?.close();
    Get.offAllNamed(AppRoutes.tabview);
  }

  //toggleMic() method allows turning the mic on or off
  //after the state of mic is toggled by user 
  //use setMicrophoneEnabled() method of livekitRoom to update partcipant's mic state
  void toggleMic() async {
    isMicOn.value = !isMicOn.value;
    await Get.find<LiveKitController>().liveKitRoom.localParticipant?.setMicrophoneEnabled(isMicOn.value);
  }
  
  //toggleLoudSpeaker() method toggles loud speaker
  void toggleLoudSpeaker(){
    isLoudSpeakerOn.value = !isLoudSpeakerOn.value;
    //enable or disable loud speaker
    Hardware.instance.setSpeakerphoneOn(isLoudSpeakerOn.value);
  }

  //endChat() method deletes the document associated with the user who has left the chat
  Future<void> endChat() async{
    subscription?.close;
    await databases.deleteDocument(databaseId: masterDatabaseId, collectionId: activePairsCollectionId, documentId: activePairDocId!);
    await Get.delete<LiveKitController>(force: true);
    Get.offAllNamed(AppRoutes.tabview);
  }
}
