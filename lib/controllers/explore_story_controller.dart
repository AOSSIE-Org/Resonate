import 'dart:developer';
import 'dart:ui';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/models/chapter.dart';
import 'package:resonate/models/story.dart';
import 'package:resonate/services/appwrite_service.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/enums/story_category.dart';

class ExploreStoryController extends GetxController {
  final Databases databases = AppwriteService.getDatabases();
  final authStateController = Get.put(AuthStateController());
  List<Story> recommendedStories = [];
  List<Story> userCreatedStories = [];
  List<Story> searchResponseStories = [];


  // Functions TBD
  // Create Story Func, Fetch chapter and Is liked 

  // Need to research a little before implementing
  Future<void> searchStories(String query) async {
    await databases.listDocuments(
        databaseId: storyDatabaseId,
        collectionId: storyCollectionId,
        queries: [Query.or([])]);
  }

  Future<void> fetchUserCreatedStories() async {
    List<Document> storyDocuments = [];
    try {
      storyDocuments = await databases.listDocuments(
          databaseId: storyDatabaseId,
          collectionId: storyCollectionId,
          queries: [
            Query.equal('creatorId', authStateController.uid)
          ]).then((value) => value.documents);
    } on AppwriteException catch (e) {
      log('Failed to fetch user created stories: ${e.message}');
    }

    userCreatedStories = await convertAppwriteDocModelToStoryModel(storyDocuments);
  }


  Future<void> likeStoryFromUserAccount(String storyId) async {
    try {
      await databases.createDocument(
          databaseId: storyDatabaseId,
          collectionId: likeCollectionId,
          documentId: ID.unique(),
          data: {'uId': authStateController.uid, 'storyId': storyId});
    } on AppwriteException catch (e) {
      log('Failed to like a story: ${e.message}');
    }
  }

  Future<List<Chapter>> fetchChaptersForStory(String storyId) async {
    List<Document> chapterDocuments = await databases.listDocuments(
        databaseId: storyDatabaseId,
        collectionId: chapterCollectionId,
        queries: [
          Query.equal('storyId', storyId)
        ]).then((value) => value.documents);

    List<Chapter> currentStoryChapters = chapterDocuments.map((value) {
      Color tintColor = Color(int.parse("0xff${value.data['tintColor']}"));
      return Chapter(
          value.data['title'],
          value.data['coverImgUrl'],
          value.data['description'],
          value.data['lyrics'],
          value.data['mp3FileUrl'],
          value.data['totalMin'],
          tintColor);
    }).toList();

    return currentStoryChapters;
  }

  Future<bool> checkIfStoryLikedByUser(String storyId) async {
    List<Document> userLikeDocuments = await databases.listDocuments(
        databaseId: storyDatabaseId,
        collectionId: likeCollectionId,
        queries: [
          Query.and([Query.equal('uid', authStateController.uid)]),
          Query.equal('storyId', storyId)
        ]).then((value) => value.documents);

    return userLikeDocuments.isNotEmpty;
  }

  Future<void> fetchStoryRecommendation() async {
    List<Document> storyDocuments = [];
    try {
      storyDocuments = await databases.listDocuments(
          databaseId: storyDatabaseId,
          collectionId: storyCollectionId,
          queries: [Query.limit(10)]).then((value) => value.documents);
    } on AppwriteException catch (e) {
      log('Failed to fetch stories: ${e.message}');
    }

    recommendedStories =
        await convertAppwriteDocModelToStoryModel(storyDocuments);
  }

  Future<List<Story>> convertAppwriteDocModelToStoryModel(
      List<Document> storyDocuments) async {
    return await Future.wait(storyDocuments.map((value) async {
      StoryCategory category = StoryCategory.values.firstWhere(
        (element) {
          return element.name == value.data['category'];
        },
      );

      List<Chapter> storyChapters = [];
      try {
        storyChapters = await fetchChaptersForStory(value.$id);
      } on AppwriteException catch (e) {
        log('Failed to fetch chapters for story: ${e.message}');
      }

      bool hasUserLiked = false;
      try {
        hasUserLiked = await checkIfStoryLikedByUser(value.$id);
      } on AppwriteException catch (e) {
        log('Failed to check if user has liked the story: ${e.message}');
      }

      return Story(
          value.data['title'],
          value.$id,
          value.data['description'],
          category,
          value.data['coverImgUrl'],
          value.data['creatorId'],
          value.data['creatorName'],
          value.data['creatorImgUrl'],
          DateTime.parse(value.$createdAt),
          value.data['likes'],
          hasUserLiked,
          value.data['totalMin'],
          value.data['tintColor'],
          storyChapters);
    }).toList());
  }
}
