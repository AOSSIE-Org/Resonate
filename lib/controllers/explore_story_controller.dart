import 'dart:async';
import 'dart:developer';
import 'dart:io' as io;
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/models/chapter.dart';
import 'package:resonate/models/story.dart';
import 'package:resonate/services/appwrite_service.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/enums/story_category.dart';

class ExploreStoryController extends GetxController {
  final Databases databases = AppwriteService.getDatabases();
  final Storage storage = AppwriteService.getStorage();
  final authStateController = Get.put(AuthStateController());
  RxList<Story> recommendedStories = <Story>[].obs;
  RxList<Story> userCreatedStories = <Story>[].obs;
  RxList<Story> userLikedStories = <Story>[].obs;
  RxList<Story> searchResponseStories = <Story>[].obs;
  RxList<Story> openedCategotyStories = <Story>[].obs;
  Rx<bool> isLoadingStoryPage = false.obs;
  Rx<bool> isSearching = false.obs;
  Rx<bool> searchBarIsEmpty = true.obs;

  @override
  void onInit() async {
    super.onInit();
    await fetchStoryRecommendation();
    await fetchUserCreatedStories();
    await fetchUserLikedStories();
  }

  Future<void> fetchMoreDetailsForSelectedStory(Story story) async {
    isLoadingStoryPage.value = true;

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
    Document doc = await databases.getDocument(
        databaseId: storyDatabaseId,
        collectionId: storyCollectionId,
        documentId: story.storyId,
        queries: [
          Query.select(["likes"])
        ]);

    int likes = doc.data['likes'];

    story.chapters = storyChapters;
    story.isLikedByCurrentUser.value = hasUserLiked;
    story.likesCount.value = likes;
    isLoadingStoryPage.value = false;
  }

  Future<void> updateLikesCountAndUserLikeStatus(Story story) async {
    Document doc = await databases.getDocument(
        databaseId: storyDatabaseId,
        collectionId: storyCollectionId,
        documentId: story.storyId,
        queries: [
          Query.select(["likes"])
        ]);

    int likes = doc.data['likes'];

    bool hasUserLiked = await checkIfStoryLikedByUser(story.storyId);

    story.likesCount.value = likes;
    story.isLikedByCurrentUser.value = hasUserLiked;
  }

  Future<void> searchStories(String query) async {
    List<Document> storyDocuments = await databases.listDocuments(
        databaseId: storyDatabaseId,
        collectionId: storyCollectionId,
        queries: [
          Query.or([
            Query.search('title', query),
            Query.search('creatorName', query),
            Query.search('description', query)
          ]),
          Query.limit(16)
        ]).then((value) => value.documents);

    searchResponseStories.value =
        await convertAppwriteDocListToStoryList(storyDocuments);
  }

  Future<void> updateStoriesPlayDurationLength(
      List<Chapter> chapters, String storyId) async {
    int totalStoryDuration = chapters.fold(0, (sum, chapter) {
      return sum + chapter.playDuration;
    });

    try {
      await databases.updateDocument(
          databaseId: storyDatabaseId,
          collectionId: storyCollectionId,
          documentId: storyId,
          data: {"playDuration": totalStoryDuration});
    } on AppwriteException catch (e) {
      log("Failed to update story duration: ${e.message}");
    }
  }

  Future<void> pushChaptersToStory(
      List<Chapter> chapters, String storyId) async {
    for (Chapter chapter in chapters) {
      String colorString = chapter.tintColor.toString();
      String extractedColor = colorString.substring(8, 14);

      String coverImgUrl = chapter.coverImageUrl;

      if (!coverImgUrl.contains("http")) {
        coverImgUrl = await uploadFileToAppwriteGetUrl(
            storyBucketId, storyId, coverImgUrl, "story cover");
      }

      String audioFileId = 'audioFor${chapter.chapterId}';

      String audioFileUrl = await uploadFileToAppwriteGetUrl(
          storyBucketId, audioFileId, chapter.audioFileUrl, "audio file");
      await databases.createDocument(
          databaseId: storyDatabaseId,
          collectionId: chapterCollectionId,
          documentId: chapter.chapterId,
          data: {
            'title': chapter.title,
            'description': chapter.description,
            'coverImgUrl': coverImgUrl,
            'lyrics': chapter.lyrics,
            'playDuration': chapter.playDuration,
            'tintColor': extractedColor,
            'storyId': storyId,
            'audioFileUrl': audioFileUrl
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

    openedCategotyStories.value =
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

  Future<Chapter> createChapter(String title, String description,
      String coverImgPath, String audioFilePath, String lyricsFilePath) async {
    Metadata metadata =
        await MetadataRetriever.fromFile(io.File(audioFilePath));
    log("logging duration ${metadata.trackDuration}");
    int playDuration = metadata.trackDuration!;
    String chapterId = ID.unique();
    Color primaryColor;

    if (!coverImgPath.contains('http')) {
      PaletteGenerator paletteGenerator =
          await PaletteGenerator.fromImageProvider(
              FileImage(io.File(coverImgPath)));

      primaryColor = paletteGenerator.dominantColor!.color;
    } else {
      primaryColor = const Color(0xffcbc6c6);
    }
    String lyrics = '';
    if (lyricsFilePath != '') {
      lyrics = await io.File(lyricsFilePath).readAsString();
    }

    // coverImageUrl and audioFileUrl recieve paths while the chapter creation process
    // as cannot push files to storage to get URL unless user is final on creating a story

    return Chapter(chapterId, title, coverImgPath, description, lyrics,
        audioFilePath, playDuration, primaryColor);
  }

  Future<void> createStory(
      String title,
      String desciption,
      StoryCategory category,
      String coverImgRef,
      int storyPlayDuration,
      List<Chapter> chapters) async {
    String storyId = ID.unique();

    String coverImgUrl = coverImgRef;
    Color primaryColor;

    if (!coverImgUrl.contains("http")) {
      PaletteGenerator paletteGenerator =
          await PaletteGenerator.fromImageProvider(
              FileImage(io.File(coverImgUrl)));
      primaryColor = paletteGenerator.dominantColor!.color;
      coverImgUrl = await uploadFileToAppwriteGetUrl(
          storyBucketId, storyId, coverImgRef, "story cover");
    } else {
      primaryColor = const Color(0xffcbc6c6);
    }

    try {
      await pushChaptersToStory(chapters, storyId);
    } on AppwriteException catch (e) {
      log("failed to push chapters to appwrite: ${e.message}");
    }

    String colorString = primaryColor.toString();
    String extractedColor = colorString.substring(8, 14);
    try {
      await databases.createDocument(
          databaseId: storyDatabaseId,
          collectionId: storyCollectionId,
          documentId: storyId,
          data: {
            'title': title,
            'description': desciption,
            'category': category.name,
            'coverImgUrl': coverImgUrl,
            'creatorId': authStateController.uid,
            'creatorName': authStateController.displayName,
            'creatorImgUrl': authStateController.profileImageUrl,
            'likes': 0,
            'playDuration': storyPlayDuration,
            'tintColor': extractedColor
          });
    } on AppwriteException catch (e) {
      log("failed to upload story to appwrite: ${e.message}");
    }

    await fetchUserCreatedStories();
    await fetchStoryRecommendation();
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

    userLikedStories.value =
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

    fetchUserCreatedStories();
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

    userCreatedStories.value =
        await convertAppwriteDocListToStoryList(storyDocuments);
  }

  Future<void> likeStoryFromUserAccount(Story story) async {
    try {
      await databases.createDocument(
          databaseId: storyDatabaseId,
          collectionId: likeCollectionId,
          documentId: ID.unique(),
          data: {'uId': authStateController.uid, 'storyId': story.storyId});
    } on AppwriteException catch (e) {
      log('Failed to like a story: ${e.message}');
    }

    try {
      await databases.updateDocument(
          databaseId: storyDatabaseId,
          collectionId: storyCollectionId,
          documentId: story.storyId,
          data: {"likes": story.likesCount.value + 1});
    } on AppwriteException catch (e) {
      log("Failed to add one story like: ${e.message}");
    }

    fetchUserLikedStories();
  }

  Future<void> unlikeStoryFromUserAccount(Story story) async {
    List<Document> userLikeDocuments = [];
    try {
      userLikeDocuments = await databases.listDocuments(
          databaseId: storyDatabaseId,
          collectionId: likeCollectionId,
          queries: [
            Query.and([
              Query.equal('uId', authStateController.uid),
              Query.equal('storyId', story.storyId)
            ]),
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

    try {
      await databases.updateDocument(
          databaseId: storyDatabaseId,
          collectionId: storyCollectionId,
          documentId: story.storyId,
          data: {"likes": story.likesCount.value - 1});
    } on AppwriteException catch (e) {
      log("Failed to reduce one story like: ${e.message}");
    }

    fetchUserLikedStories();
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
          value.$id,
          value.data['title'],
          value.data['coverImgUrl'],
          value.data['description'],
          value.data['lyrics'],
          value.data['audioFileUrl'],
          value.data['playDuration'],
          tintColor);
    }).toList();

    return currentStoryChapters;
  }

  Future<bool> checkIfStoryLikedByUser(String storyId) async {
    List<Document> userLikeDocuments = await databases.listDocuments(
        databaseId: storyDatabaseId,
        collectionId: likeCollectionId,
        queries: [
          Query.and([
            Query.equal('uId', authStateController.uid),
            Query.equal('storyId', storyId)
          ]),
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

    recommendedStories.value =
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

      Color tintColor = Color(int.parse("0xff${value.data['tintColor']}"));

      return Story(
        title: value.data['title'],
        storyId: value.$id,
        description: value.data['description'],
        userIsCreator: value.data['creatorId'] == authStateController.uid,
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
    }).toList());
  }
}
