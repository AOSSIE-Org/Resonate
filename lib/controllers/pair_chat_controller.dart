import 'dart:async';
import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:get/get.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/models/resonate_user.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:resonate/services/appwrite_service.dart';
import 'package:resonate/services/room_service.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/views/widgets/rating_sheet.dart';

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
  RxDouble pairRating = 2.5.obs;

  Client client = AppwriteService.getClient();
  final Realtime realtime = AppwriteService.getRealtime();
  final Databases databases = AppwriteService.getDatabases();
  late RealtimeSubscription? subscription;
  RealtimeSubscription? userAddedSubscription;
  AuthStateController authController = Get.find<AuthStateController>();

  RxList<ResonateUser> usersList = <ResonateUser>[].obs;
  final RxBool isUserListLoading = true.obs;

  void quickMatch() async {
    String uid = authController.uid!;
    String userName = authController.userName!;

    // Open realtime stream to check whether the request is paired
    getRealtimeStream();

    Map<String, dynamic> requestData = {
      "languageIso": languageIso,
      "isAnonymous": isAnonymous.value,
      "uid": uid,
      "isRandom": true,
    };
    requestData.addIf(!isAnonymous.value, "userName", userName);

    // Add request to pair-request collection
    Document requestDoc = await databases.createDocument(
      databaseId: masterDatabaseId,
      collectionId: pairRequestCollectionId,
      documentId: ID.unique(),
      data: requestData,
    );
    requestDocId = requestDoc.$id;

    // Go to pairing screen
    Get.toNamed(AppRoutes.pairing);
  }

  void choosePartner() async {
    checkForNewUsers();
    getRealtimeStream();
    isAnonymous.value = false;
    Map<String, dynamic> requestData = {
      "languageIso": languageIso,
      "isAnonymous": false,
      "uid": authController.uid,
      "isRandom": false,
      "profileImageUrl": authController.profileImageUrl,
      "userName": authController.userName,
      "name": authController.displayName,
      "userRating": authController.ratingTotal / authController.ratingCount,
    };

    // Add request to pair-request collection
    Document requestDoc = await databases.createDocument(
      databaseId: masterDatabaseId,
      collectionId: pairRequestCollectionId,
      documentId: ID.unique(),
      data: requestData,
    );
    requestDocId = requestDoc.$id;
    Get.toNamed(AppRoutes.pairChatUsers);
  }

  Future<void> convertToRandom() async {
    userAddedSubscription?.close();
    getRealtimeStream();
    await databases.updateDocument(
      databaseId: masterDatabaseId,
      collectionId: pairRequestCollectionId,
      documentId: requestDocId!,
      data: {'isRandom': true},
    );
    Get.toNamed(AppRoutes.pairing);
  }

  void getRealtimeStream() {
    String uid = authController.uid!;
    String channel =
        'databases.$masterDatabaseId.collections.$activePairsCollectionId.documents';
    subscription = realtime.subscribe([channel]);
    subscription?.stream.listen((data) async {
      if (data.payload.isNotEmpty) {
        String uid1 = data.payload["uid1"];
        String uid2 = data.payload["uid2"];

        // If the request was served and the user was paired
        if (uid1 == uid || uid2 == uid) {
          log(data.toString());
          var docId = data.payload["\$id"].toString();
          String action = data.events.first.substring(
            channel.length + 1 + (docId.length) + 1,
          );
          switch (action) {
            case 'create':
              {
                if (uid1 == uid) {
                  myRoomUserId = 1;
                  pairUsername = data.payload["userName2"];
                  Document participantDoc = await databases.getDocument(
                    databaseId: userDatabaseID,
                    collectionId: usersCollectionID,
                    documentId: data.payload["uid2"],
                  );
                  pairProfileImageUrl = participantDoc.data["profileImageUrl"];
                } else {
                  myRoomUserId = 2;
                  pairUsername = data.payload["userName1"];
                  Document participantDoc = await databases.getDocument(
                    databaseId: userDatabaseID,
                    collectionId: usersCollectionID,
                    documentId: data.payload["uid1"],
                  );
                  pairProfileImageUrl = participantDoc.data["profileImageUrl"];
                }
                activePairDocId = data.payload["\$id"];
                await joinPairChat(activePairDocId, uid);
                break;
              }
            case 'delete':
              {
                endChat();
              }
          }
        }
      }
    });
  }

  Future<void> pairWithSelectedUser(ResonateUser user) async {
    log('pairing');
    await databases.createDocument(
      databaseId: masterDatabaseId,
      collectionId: activePairsCollectionId,
      documentId: ID.unique(),
      data: {
        'uid1': authController.uid,
        'uid2': user.uid,
        'userName1': authController.userName,
        'userName2': user.userName,
        'userDocId1': requestDocId,
        'userDocId2': user.docId,
      },
    );
  }

  void checkForNewUsers() {
    log('listening for new users');
    String channel =
        'databases.$masterDatabaseId.collections.$pairRequestCollectionId.documents';
    userAddedSubscription = realtime.subscribe([channel]);
    userAddedSubscription?.stream.listen((data) async {
      final event = data.events.first;
      if (data.payload.isNotEmpty) {
        if (event.endsWith('.create')) {
          log('adding new user');
          // If a new user is added to the pair request collection
          final userData = data.payload;
          final eventSplit = event.split('.');
          final docId =
              eventSplit[eventSplit.length - 2]; // Get the second last
          userData['docId'] = docId; // Add docId to the user
          ResonateUser newUser = ResonateUser.fromJson(userData);

          usersList.add(newUser);
        } else if (event.endsWith('.delete')) {
          ResonateUser removedUser = ResonateUser.fromJson(data.payload);
          usersList.removeWhere((user) => user.uid == removedUser.uid);
        }
      }
    });
  }

  Future<void> loadUsers() async {
    isUserListLoading.value = true;
    log("Loading users");
    usersList.clear();
    final result = await databases.listDocuments(
      databaseId: masterDatabaseId,
      collectionId: pairRequestCollectionId,
      queries: [
        Query.notEqual('uid', authController.uid!),
        Query.notEqual('isAnonymous', true),
        Query.limit(100),
      ],
    );
    if (result.documents.isEmpty) {
      isUserListLoading.value = false;
      return;
    } else {
      usersList.addAll(
        result.documents.map((doc) {
          final userData = doc.data;
          userData['docId'] = doc.$id; // Add docId to the user data
          ResonateUser user = ResonateUser.fromJson(userData);

          return user;
        }).toList(),
      );
    }
    isUserListLoading.value = false;
  }

  Future<void> joinPairChat(roomId, userId) async {
    await RoomService.joinLivekitPairChat(roomId: roomId, userId: userId);
    Get.toNamed(AppRoutes.pairChat);
  }

  Future<void> cancelRequest() async {
    await databases.deleteDocument(
      databaseId: masterDatabaseId,
      collectionId: pairRequestCollectionId,
      documentId: requestDocId!,
    );
    subscription?.close();
    userAddedSubscription?.close();
    Get.offNamedUntil(AppRoutes.tabview, (route) => false);
  }

  void toggleMic() async {
    isMicOn.value = !isMicOn.value;
    await Get.find<LiveKitController>().liveKitRoom.localParticipant
        ?.setMicrophoneEnabled(isMicOn.value);
  }

  void toggleLoudSpeaker() {
    isLoudSpeakerOn.value = !isLoudSpeakerOn.value;
    Hardware.instance.setSpeakerphoneOn(isLoudSpeakerOn.value);
  }

  Future<void> endChat() async {
    subscription?.close();
    try {
      await databases.deleteDocument(
        databaseId: masterDatabaseId,
        collectionId: activePairsCollectionId,
        documentId: activePairDocId!,
      );
    } catch (e) {
      if (!(e is AppwriteException && e.type == 'document_not_found')) {
        rethrow;
      }
    }
    await Get.delete<LiveKitController>(force: true);

    await Get.bottomSheet(RatingSheetWidget());
    Get.offNamedUntil(AppRoutes.tabview, (route) => false);
  }
}
