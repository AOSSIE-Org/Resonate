import 'dart:async';
import 'dart:developer';
import 'dart:io' as io;
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/models/chapter.dart';
import 'package:resonate/models/story.dart';
import 'package:resonate/services/appwrite_service.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/enums/story_category.dart';

final exploreStoryController = Get.put(ExploreStoryController());

class ExploreStoryController extends GetxController {
  final Databases databases = AppwriteService.getDatabases();
  final Storage storage = AppwriteService.getStorage();
  final authStateController = Get.put(AuthStateController());
  List<Story> recommendedStories = [];
  List<Story> userCreatedStories = [];
  List<Story> userLikedStories = [];
  List<Story> searchResponseStories = [];
  List<Story> openedCategotyStories = [];

  @override
  void onInit() async {
    super.onInit();
    await fetchStoryRecommendation();
    await fetchUserCreatedStories();
    await fetchUserLikedStories();
  }

  // Need to research a little before implementing - kept for slight future
  Future<void> searchStories(String query) async {
    await databases.listDocuments(
        databaseId: storyDatabaseId,
        collectionId: storyCollectionId,
        queries: [
          Query.or([Query.search('Title', 'mist')])
        ]);
  }

  Future<void> pushChaptersToStory(
      List<Chapter> chapters, String storyId) async {
    for (Chapter chapter in chapters) {
      await databases.createDocument(
          databaseId: storyDatabaseId,
          collectionId: chapterCollectionId,
          documentId: chapter.chapterId,
          data: {
            'title': chapter.title,
            'description': chapter.description,
            'coverImgurl': chapter.coverImageUrl,
            'lyrics': chapter.lyrics,
            'totalMin': chapter.playDuration,
            'tintColor': chapter.tintColor.toString(),
            'storyId': storyId,
            'audioFileUrl': chapter.audioFileUrl
          });
    }
  }

  Future<void> fetchStoryByCategory(StoryCategory category) async {
    List<Document> storyDocuments = [];
    try {
      storyDocuments = await databases.listDocuments(
          databaseId: storyDatabaseId,
          collectionId: storyCollectionId,
          queries: [
            Query.and([Query.limit(15), Query.equal('category', category.name)])
          ]).then((value) => value.documents);
    } on AppwriteException catch (e) {
      log('Failed to fetch stories for categories: ${e.message}');
    }

    openedCategotyStories =
        await convertAppwriteDocListToStoryList(storyDocuments);
  }

  Future<String> uploadFileToAppwriteGetUrl(String bucketId, String fileId,
      String filePath, String fileIdentificationForError) async {
    try {
      await storage.createFile(
        bucketId: storyBucketId,
        fileId: fileId,
        file: InputFile.fromPath(path: filePath),
      );
    } on AppwriteException catch (e) {
      log("failed to upload $fileIdentificationForError to appwrite: ${e.message}");
    }

    return "$appwriteEndpoint/storage/buckets/$bucketId/files/$fileId/view?project=$appwriteProjectId";
  }

  Future<Chapter> createChapter(
      String title,
      String description,
      String coverImgPath,
      String audioFilePath,
      String lyricsFilePath,
      String audioPlayDuration) async {
    String chapterId = ID.unique();

    PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
            FileImage(io.File(coverImgPath)));

    String coverImgUrl = await uploadFileToAppwriteGetUrl(
        storyBucketId, chapterId, coverImgPath, "chapter cover");

    String audioFileId = 'audioFor$chapterId';

    String audioFileUrl = await uploadFileToAppwriteGetUrl(
        storyBucketId, audioFileId, audioFilePath, "audio file");

    String lyrics = await io.File(lyricsFilePath).readAsString();

    return Chapter(chapterId, title, coverImgUrl, description, lyrics,
        audioFileUrl, audioPlayDuration, paletteGenerator.dominantColor!.color);
  }

  Future<void> createStory(
      String title,
      String desciption,
      StoryCategory category,
      String coverImgPath,
      String storyTotalMin,
      List<Chapter> chapters) async {
    String storyId = ID.unique();

    String coverImgUrl = await uploadFileToAppwriteGetUrl(
        storyBucketId, storyId, coverImgPath, "story cover");

    PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
            FileImage(io.File(coverImgPath)));

    try {
      await pushChaptersToStory(chapters, storyId);
    } on AppwriteException catch (e) {
      log("failed to push chapters to appwrite: ${e.message}");
    }

    try {
      await databases.createDocument(
          databaseId: storyDatabaseId,
          collectionId: storyCollectionId,
          documentId: storyId,
          data: {
            'title': title,
            'description': desciption,
            'category': category,
            'coverImgUrl': coverImgUrl,
            'creatorId': authStateController.uid,
            'creatorName': authStateController.displayName,
            'creatorImgUrl': authStateController.profileImageUrl,
            'likes': 0,
            'totalMin': storyTotalMin,
            'tintColor': paletteGenerator.dominantColor!.color.toString()
          });
    } on AppwriteException catch (e) {
      log("failed to upload story to appwrite: ${e.message}");
    }
  }

  Future<void> fetchUserLikedStories() async {
    List<Document> userLikedDocuments = await databases.listDocuments(
        databaseId: storyDatabaseId,
        collectionId: likeCollectionId,
        queries: [
          Query.equal('uId', authStateController.uid)
        ]).then((value) => value.documents);

    List<Document> userLikedStoriesDocuments =
        await Future.wait(userLikedDocuments.map((value) async {
      return await databases.getDocument(
          databaseId: storyDatabaseId,
          collectionId: storyCollectionId,
          documentId: value.data['storyId']);
    }).toList());

    userLikedStories =
        await convertAppwriteDocListToStoryList(userLikedStoriesDocuments);
  }

  Future<void> deleteStory(Story story) async {
    try {
      await storage.deleteFile(bucketId: storyBucketId, fileId: story.storyId);
    } on AppwriteException catch (e) {
      log('failed to delete story cover image ${e.message}');
    }

    try {
      await deleteAllStoryChapters(story.chapters);
    } on AppwriteException catch (e) {
      log('failed to delete all story chapters ${e.message}');
    }

    try {
      await deleteAllStoryLikes(story.storyId);
    } on AppwriteException catch (e) {
      log('failed to delete all story likes: ${e.message}');
    }

    try {
      await databases.deleteDocument(
          databaseId: storyDatabaseId,
          collectionId: storyCollectionId,
          documentId: story.storyId);
    } on AppwriteException catch (e) {
      log("failed to delete a document: ${e.message}");
    }
  }

  Future<void> deleteAllStoryLikes(String storyId) async {
    List<Document> storyLikeDocuments = await databases.listDocuments(
        databaseId: storyDatabaseId,
        collectionId: likeCollectionId,
        queries: [
          Query.equal('storyId', storyId)
        ]).then((value) => value.documents);

    for (Document like in storyLikeDocuments) {
      await databases.deleteDocument(
          databaseId: storyDatabaseId,
          collectionId: likeCollectionId,
          documentId: like.$id);
    }
  }

  Future<void> deleteChapter(Chapter chapter) async {
    try {
      await storage.deleteFile(
          bucketId: storyBucketId, fileId: chapter.chapterId);
    } on AppwriteException catch (e) {
      log("failed to delete chapter cover img ${e.message}");
    }
    try {
      await storage.deleteFile(
          bucketId: storyBucketId, fileId: 'audioFor${chapter.chapterId}');
    } on AppwriteException catch (e) {
      log("failed to delete chapter audio file ${e.message}");
    }
    try {
      await databases.deleteDocument(
          databaseId: storyDatabaseId,
          collectionId: chapterCollectionId,
          documentId: chapter.chapterId);
    } on AppwriteException catch (e) {
      log("failed to delete chapter document ${e.message}");
    }
  }

  Future<void> deleteAllStoryChapters(List<Chapter> chapters) async {
    for (Chapter chapter in chapters) {
      await deleteChapter(chapter);
    }
  }

  Future<Story> fetchMoreDetailsForSelectedSearchResultStory(
      Story story) async {
    List<Chapter> storyChapters = [];
    try {
      storyChapters = await fetchChaptersForStory(story.storyId);
    } on AppwriteException catch (e) {
      log("failed to fetch story chapters for selected search result query: ${e.message}");
    }

    bool hasUserLiked = false;
    try {
      hasUserLiked = await checkIfStoryLikedByUser(story.storyId);
    } on AppwriteException catch (e) {
      log("failed to check if user liked story for selected search result query ${e.message}");
    }

    story.chapters = storyChapters;
    story.isLikedByCurrentUser = hasUserLiked;
    return story;
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

    userCreatedStories =
        await convertAppwriteDocListToStoryList(storyDocuments);
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

  Future<void> unlikeStoryFromUserAccount(String storyId) async {
    List<Document> userLikeDocuments = [];
    try {
      userLikeDocuments = await databases.listDocuments(
          databaseId: storyDatabaseId,
          collectionId: likeCollectionId,
          queries: [
            Query.and([Query.equal('uid', authStateController.uid)]),
            Query.equal('storyId', storyId)
          ]).then((value) => value.documents);
    } on AppwriteException catch (e) {
      log('Failed to fetch Like Document: ${e.message}');
    }

    try {
      await databases.deleteDocument(
        databaseId: storyDatabaseId,
        collectionId: likeCollectionId,
        documentId: userLikeDocuments.first.$id,
      );
    } on AppwriteException catch (e) {
      log('Failed to Unlike i.e delete Like Document: ${e.message}');
    }
  }

  // write unlike story function

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
          value.$id,
          value.data['title'],
          value.data['coverImgUrl'],
          value.data['description'],
          value.data['lyrics'],
          value.data['audioFileUrl'],
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
        await convertAppwriteDocListToStoryList(storyDocuments);
  }

  Future<List<Story>> convertAppwriteDocListToStoryList(
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
          value.data['creatorId'] == authStateController.uid,
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
