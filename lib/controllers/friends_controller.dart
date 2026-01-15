import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/models/friends_model.dart';
import 'package:resonate/services/appwrite_service.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/enums/friend_request_status.dart';

class FriendsController extends GetxController {
  final Databases databases;
  final FirebaseMessaging firebaseMessaging;
  final Functions functions;
  final AuthStateController authStateController;
  final RxList<FriendsModel> friendsList = <FriendsModel>[].obs;
  final RxList<FriendsModel> friendRequestsList = <FriendsModel>[].obs;
  final RxBool isLoadingFriends = false.obs;
  late RealtimeSubscription friendRequestsSubscription;
  final Realtime realtime;

  FriendsController({
    Databases? databases,
    Functions? functions,
    Realtime? realtime,
    FirebaseMessaging? firebaseMessaging,
    AuthStateController? authStateController,
  }) : databases = databases ?? AppwriteService.getDatabases(),
       functions = functions ?? AppwriteService.getFunctions(),
       realtime = realtime ?? AppwriteService.getRealtime(),
       firebaseMessaging = firebaseMessaging ?? FirebaseMessaging.instance,
       authStateController =
           authStateController ??
           Get.put<AuthStateController>(AuthStateController());

  @override
  void onInit() async {
    super.onInit();
    await getFriendsList();
    listenForChangesInFriends();
  }

  Future<void> sendFriendRequest(
    String recieverId,
    String recieverProfileImageUrl,
    String recieverUsername,
    String recieverName,
    double recieverRating,
  ) async {
    final docId = ID.unique();
    final userFCMToken = await firebaseMessaging.getToken();

    final friendModel = FriendsModel(
      senderId: authStateController.uid!,
      recieverId: recieverId,
      senderProfileImgUrl: authStateController.profileImageUrl!,
      recieverProfileImgUrl: recieverProfileImageUrl,
      senderUsername: authStateController.userName!,
      recieverUsername: recieverUsername,
      senderName: authStateController.displayName!,
      recieverName: recieverName,
      requestStatus: FriendRequestStatus.sent,
      requestSentByUserId: authStateController.uid!,
      docId: docId,
      senderFCMToken: userFCMToken,
      users: [authStateController.uid!, recieverId],
      senderRating:
          authStateController.ratingTotal / authStateController.ratingCount,
      recieverRating: recieverRating,
    );
    await databases.createDocument(
      databaseId: userDatabaseID,
      collectionId: friendsCollectionID,
      documentId: docId,
      data: friendModel.toJson(),
    );
    friendRequestsList.add(friendModel);
  }

  Future<void> removeFriend(FriendsModel friendModel) async {
    await databases.deleteDocument(
      databaseId: userDatabaseID,
      collectionId: friendsCollectionID,
      documentId: friendModel.docId,
    );
    friendsList.removeWhere((friend) => friend.docId == friendModel.docId);
    friendRequestsList.removeWhere(
      (request) => request.docId == friendModel.docId,
    );
  }

  Future<void> getFriendsList() async {
    isLoadingFriends.value = true;
    friendsList.clear();
    friendRequestsList.clear();

    final userDoc = await databases.getDocument(
      databaseId: userDatabaseID,
      collectionId: usersCollectionID,
      documentId: authStateController.uid!,
    );
    for (var friend in (userDoc.data["friends"] ?? []) as List<dynamic>) {
      final friendModel = FriendsModel.fromJson(friend);
      if (friendModel.requestStatus == FriendRequestStatus.accepted) {
        friendsList.add(friendModel);
      } else {
        friendRequestsList.add(friendModel);
      }
    }
    isLoadingFriends.value = false;
  }

  Future<void> acceptFriendRequest(FriendsModel friendModel) async {
    final userFCMToken = await firebaseMessaging.getToken();

    final updatedFriendModel = friendModel.copyWith(
      requestStatus: FriendRequestStatus.accepted,
      recieverFCMToken: userFCMToken,
      users: [friendModel.senderId, friendModel.recieverId],
    );

    await databases.updateDocument(
      databaseId: userDatabaseID,
      collectionId: friendsCollectionID,
      documentId: friendModel.docId,
      data: updatedFriendModel.toJson(),
    );

    friendRequestsList.removeWhere(
      (request) => request.docId == friendModel.docId,
    );
    friendsList.add(updatedFriendModel);
  }

  Future<void> declineFriendRequest(FriendsModel friendModel) async {
    await databases.deleteDocument(
      databaseId: userDatabaseID,
      collectionId: friendsCollectionID,
      documentId: friendModel.docId,
    );
    friendRequestsList.removeWhere(
      (request) => request.docId == friendModel.docId,
    );
  }

  void listenForChangesInFriends() {
    String channel =
        'databases.$userDatabaseID.collections.$friendsCollectionID.documents';
    friendRequestsSubscription = realtime.subscribe([channel]);
    friendRequestsSubscription.stream.listen((data) async {
      if (data.payload.isNotEmpty) {
        if (data.payload['senderId'] == authStateController.uid ||
            data.payload['recieverId'] == authStateController.uid) {
          log('data updated');
          // If a change is detected in the user doc
          getFriendsList();
        }
      }
    });
  }
}
