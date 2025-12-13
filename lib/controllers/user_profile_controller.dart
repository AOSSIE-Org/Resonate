import 'dart:developer';
import 'dart:ui';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/models/follower_user_model.dart';
import 'package:resonate/models/story.dart';
import 'package:resonate/services/appwrite_service.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/enums/story_category.dart';

class UserProfileController extends GetxController {
  final Databases databases;

  final AuthStateController authStateController;
  RxList<FollowerUserModel> searchedUserFollowers = <FollowerUserModel>[].obs;
  RxList<Story> searchedUserStories = <Story>[].obs;
  RxList<Story> searchedUserLikedStories = <Story>[].obs;
  Rx<bool> isLoadingProfilePage = false.obs;
  Rx<bool> isFollowingUser = false.obs;
  String? followerDocumentId;
  Rx<ResonateUser?> searchedUser = Rx<ResonateUser?>(null);

  UserProfileController({
    Databases? databases,
    AuthStateController? authStateController,
  }) : databases = databases ?? AppwriteService.getDatabases(),
       authStateController =
           authStateController ??
           Get.put<AuthStateController>(AuthStateController());
  Future<void> initializeProfile(String creatorId) async {
    isLoadingProfilePage.value = true;
    try {
      Document userDocument = await databases.getDocument(
        databaseId: userDatabaseID,
        collectionId: usersCollectionID,
        documentId: creatorId,
      );
      searchedUser.value = ResonateUser.fromJson(userDocument.data);

      await Future.wait([
        fetchUserCreatedStories(creatorId),
        fetchUserLikedStories(creatorId),
        fetchUserFollowers(creatorId),
      ]);
    } catch (e) {
      log('initializeProfile failed: $e');
    } finally {
      isLoadingProfilePage.value = false;
    }
  }

  Future<void> fetchUserLikedStories(String creatorId) async {
    List<Document> userLikedDocuments = await databases
        .listDocuments(
          databaseId: storyDatabaseId,
          collectionId: likeCollectionId,
          queries: [Query.equal('uId', creatorId)],
        )
        .then((value) => value.documents);

    List<Document> userLikedStoriesDocuments = await Future.wait(
      userLikedDocuments.map((value) async {
        return await databases.getDocument(
          databaseId: storyDatabaseId,
          collectionId: storyCollectionId,
          documentId: value.data['storyId'],
        );
      }).toList(),
    );

    searchedUserLikedStories.value = await convertAppwriteDocListToStoryList(
      userLikedStoriesDocuments,
    );
  }

  Future<List<Story>> convertAppwriteDocListToStoryList(
    List<Document> storyDocuments,
  ) async {
    return await Future.wait(
      storyDocuments.map((value) async {
        StoryCategory category = StoryCategory.values.byName(
          value.data['category'],
        );

        Color tintColor = Color(int.parse("0xff${value.data['tintColor']}"));

        return Story(
          title: value.data['title'],
          storyId: value.$id,
          description: value.data['description'],
          userIsCreator: false,
          category: category,
          coverImageUrl: value.data['coverImgUrl'],
          creatorId: value.data['creatorId'],
          creatorName: value.data['creatorName'],
          creatorImgUrl: value.data['creatorImgUrl'],
          creationDate: DateTime.parse(value.$createdAt),
          likesCount: value.data['likes'],
          isLikedByCurrentUser: false,
          playDuration: value.data['playDuration'],
          tintColor: tintColor,
          chapters: [],
        );
      }).toList(),
    );
  }

  Future<void> fetchUserCreatedStories(String creatorId) async {
    List<Document> storyDocuments = [];
    try {
      storyDocuments = await databases
          .listDocuments(
            databaseId: storyDatabaseId,
            collectionId: storyCollectionId,
            queries: [Query.equal('creatorId', creatorId)],
          )
          .then((value) => value.documents);
    } on AppwriteException catch (e) {
      log('Failed to fetch user created stories: ${e.message}');
    }
    searchedUserStories.value = await convertAppwriteDocListToStoryList(
      storyDocuments,
    );
  }

  Future<void> fetchUserFollowers(String userId) async {
    Document userDocument = await databases.getDocument(
      databaseId: userDatabaseID,
      collectionId: usersCollectionID,
      documentId: userId,
    );

    searchedUserFollowers.value =
        (userDocument.data['followers'] as List<dynamic>)
            .map((doc) => FollowerUserModel.fromJson(doc))
            .toList();
    searchedUserFollowers
        .where((follower) {
          return follower.uid == authStateController.uid!;
        })
        .forEach((follower) {
          isFollowingUser.value = true;
          followerDocumentId = follower.docId;
        });
  }

  Future<void> followCreator(String creatorId) async {
    final fcmToken = await authStateController.messaging.getToken();
    final FollowerUserModel follower = FollowerUserModel(
      docId: ID.unique(),
      uid: authStateController.uid!,
      username: authStateController.userName!,
      profileImageUrl: authStateController.profileImageUrl!,
      name: authStateController.displayName!,
      fcmToken: fcmToken!,
      followingUserId: creatorId,
      followerRating:
          authStateController.ratingTotal / authStateController.ratingCount,
    );

    await databases.createDocument(
      databaseId: userDatabaseID,
      collectionId: followersCollectionID,
      documentId: follower.docId,
      data: follower.toJson(),
    );
    searchedUserFollowers.add(follower);
    isFollowingUser.value = true;
    followerDocumentId = follower.docId;
    return;
  }

  Future<void> unfollowCreator() async {
    await databases.deleteDocument(
      databaseId: userDatabaseID,
      collectionId: followersCollectionID,
      documentId: followerDocumentId ?? "",
    );
    isFollowingUser.value = false;
    searchedUserFollowers.removeWhere(
      (follower) => follower.docId == followerDocumentId,
    );
  }
}
