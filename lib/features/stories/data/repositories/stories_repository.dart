import 'dart:convert';
import 'dart:developer';
import 'dart:io' as io;

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:flutter/material.dart' hide Row;
import 'package:meilisearch/meilisearch.dart';
import 'package:resonate/core/providers/appwrite_providers.dart';
import 'package:resonate/features/auth/model/auth_user.dart';
import 'package:resonate/features/stories/model/chapter.dart';
import 'package:resonate/features/stories/model/live_chapter_attendees_model.dart';
import 'package:resonate/features/stories/model/live_chapter_model.dart';
import 'package:resonate/features/stories/model/stories_failure.dart';
import 'package:resonate/features/stories/model/story.dart';
import 'package:resonate/features/stories/model/story_detail_state.dart';
import 'package:resonate/features/stories/model/story_search_state.dart';
import 'package:resonate/models/resonate_user.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/enums/story_category.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/stories_repository.g.dart';

@Riverpod(keepAlive: true)
StoriesRepository storiesRepository(Ref ref) => StoriesRepository(
  tables: ref.watch(appwriteTablesProvider),
  storage: ref.watch(appwriteStorageProvider),
  functions: ref.watch(appwriteFunctionsProvider),
);

class StoriesRepository {
  StoriesRepository({
    required TablesDB tables,
    required Storage storage,
    required Functions functions,
    MeiliSearchClient? meili,
  }) : _tables = tables,
       _storage = storage,
       _functions = functions,
       _meili =
           meili ?? MeiliSearchClient(meilisearchEndpoint, meilisearchApiKey);

  final TablesDB _tables;
  final Storage _storage;
  final Functions _functions;
  final MeiliSearchClient _meili;

  MeiliSearchIndex get _storyIndex => _meili.index('stories');
  MeiliSearchIndex get _userIndex => _meili.index('users');

  // Loaders

  Future<List<Story>> fetchRecommendedStories(String currentUid) async {
    try {
      final result = await _tables.listRows(
        databaseId: storyDatabaseId,
        tableId: storyTableId,
        queries: [Query.limit(10)],
      );
      return _rowsToStories(result.rows, currentUid);
    } on AppwriteException catch (e) {
      log('Failed to fetch recommended stories: ${e.message}');
      return [];
    }
  }

  Future<List<Story>> fetchStoriesByCategory(
    StoryCategory category,
    String currentUid,
  ) async {
    try {
      final result = await _tables.listRows(
        databaseId: storyDatabaseId,
        tableId: storyTableId,
        queries: [Query.limit(15), Query.equal('category', category.name)],
      );
      return _rowsToStories(result.rows, currentUid);
    } on AppwriteException catch (e) {
      log(
        'Failed to fetch stories for category ${category.name}: ${e.message}',
      );
      return [];
    }
  }

  Future<List<Story>> fetchCreatedStories(String creatorId) async {
    try {
      final result = await _tables.listRows(
        databaseId: storyDatabaseId,
        tableId: storyTableId,
        queries: [Query.equal('creatorId', creatorId)],
      );
      return _rowsToStories(result.rows, creatorId);
    } on AppwriteException catch (e) {
      log('Failed to fetch created stories: ${e.message}');
      return [];
    }
  }

  Future<List<Story>> fetchLikedStories(String uid) async {
    try {
      final likeDocs = await _tables.listRows(
        databaseId: storyDatabaseId,
        tableId: likeTableId,
        queries: [Query.equal('uId', uid)],
      );

      final storyRows = <Row>[];
      for (final like in likeDocs.rows) {
        try {
          storyRows.add(
            await _tables.getRow(
              databaseId: storyDatabaseId,
              tableId: storyTableId,
              rowId: like.data['storyId'],
            ),
          );
        } on AppwriteException catch (e) {
          log('Liked story row missing, skipping: ${e.message}');
        }
      }
      return _rowsToStories(storyRows, uid);
    } on AppwriteException catch (e) {
      log('Failed to fetch liked stories: ${e.message}');
      return [];
    }
  }

  // Loads the reactive slice of a story on the detail page.
  Future<StoryDetailState> loadStoryDetail(
    String storyId,
    String currentUid,
  ) async {
    List<Chapter> chapters = [];
    try {
      chapters = await fetchChaptersForStory(storyId);
    } on AppwriteException catch (e) {
      log('Failed to fetch story chapters: ${e.message}');
    }

    bool hasUserLiked = false;
    try {
      hasUserLiked = await checkIfStoryLikedByUser(storyId, currentUid);
    } on AppwriteException catch (e) {
      log('Failed to check story like status: ${e.message}');
    }

    int likes = 0;
    try {
      likes = await fetchLikesCount(storyId);
    } on AppwriteException catch (e) {
      log('Failed to fetch story likes count: ${e.message}');
    }

    LiveChapterModel? liveChapter;
    try {
      liveChapter = await fetchLiveChapterForStory(storyId);
    } on AppwriteException catch (e) {
      log('Failed to fetch live chapter: ${e.message}');
    }

    return StoryDetailState(
      chapters: chapters,
      likesCount: likes,
      isLikedByCurrentUser: hasUserLiked,
      liveChapter: liveChapter,
    );
  }

  Future<List<Chapter>> fetchChaptersForStory(String storyId) async {
    final result = await _tables.listRows(
      databaseId: storyDatabaseId,
      tableId: chapterTableId,
      queries: [Query.equal('storyId', storyId)],
    );

    return result.rows.map((value) {
      final tintColor = Color(int.parse("0xff${value.data['tintColor']}"));
      return Chapter(
        chapterId: value.$id,
        title: value.data['title'],
        coverImageUrl: value.data['coverImgUrl'],
        description: value.data['description'],
        lyrics: value.data['lyrics'],
        audioFileUrl: value.data['audioFileUrl'],
        playDuration: value.data['playDuration'],
        tintColor: tintColor,
      );
    }).toList();
  }

  Future<int> fetchLikesCount(String storyId) async {
    final doc = await _tables.getRow(
      databaseId: storyDatabaseId,
      tableId: storyTableId,
      rowId: storyId,
      queries: [
        Query.select(["likes"]),
      ],
    );
    return doc.data['likes'] as int;
  }

  Future<bool> checkIfStoryLikedByUser(String storyId, String uid) async {
    final result = await _tables.listRows(
      databaseId: storyDatabaseId,
      tableId: likeTableId,
      queries: [
        Query.and([Query.equal('uId', uid), Query.equal('storyId', storyId)]),
      ],
    );
    return result.rows.isNotEmpty;
  }

  Future<LiveChapterModel?> fetchLiveChapterForStory(String storyId) async {
    final liveDocs = await _tables.listRows(
      databaseId: storyDatabaseId,
      tableId: liveChaptersTableId,
      queries: [Query.equal('storyId', storyId)],
    );
    if (liveDocs.rows.isEmpty) return null;

    final attendeesDoc = await _tables.getRow(
      databaseId: userDatabaseID,
      tableId: liveChapterAttendeesTableId,
      rowId: liveDocs.rows.first.$id,
      queries: [
        Query.select(["*", "users.*"]),
      ],
    );

    final attendees = LiveChapterAttendeesModel.fromJson(attendeesDoc.data);
    return LiveChapterModel.fromJson(
      liveDocs.rows.first.data,
    ).copyWith(attendees: attendees);
  }

  // Search

  Future<StorySearchState> search(String query, String currentUid) async {
    final stories = await _searchStories(query, currentUid);
    final users = await _searchUsers(query, currentUid);
    return StorySearchState(stories: stories, users: users);
  }

  Future<List<Story>> _searchStories(String query, String currentUid) async {
    try {
      if (isUsingMeilisearch) {
        final result = await _storyIndex.search(
          query,
          SearchQuery(
            attributesToHighlight: ['title', 'creatorName', 'description'],
          ),
        );
        return _meiliHitsToStories(result.hits, currentUid);
      }

      final result = await _tables.listRows(
        databaseId: storyDatabaseId,
        tableId: storyTableId,
        queries: [
          Query.or([
            Query.search('title', query),
            Query.search('creatorName', query),
            Query.search('description', query),
          ]),
          Query.limit(16),
        ],
      );
      return _rowsToStories(result.rows, currentUid);
    } catch (e) {
      log('Story search failed: $e');
      return [];
    }
  }

  Future<List<ResonateUser>> _searchUsers(
    String query,
    String currentUid,
  ) async {
    try {
      if (isUsingMeilisearch) {
        final result = await _userIndex.search(
          query,
          SearchQuery(attributesToHighlight: ['name', 'username']),
        );
        return result.hits.map(_meiliHitToUser).toList();
      }

      final result = await _tables.listRows(
        databaseId: userDatabaseID,
        tableId: usersTableID,
        queries: [
          Query.or([
            Query.search('name', query),
            Query.search('username', query),
          ]),
          Query.notEqual('\$id', currentUid),
          Query.limit(16),
        ],
      );
      return result.rows.map((doc) => _rowToUser(doc.data, doc.$id)).toList();
    } catch (e) {
      log('User search failed: $e');
      return [];
    }
  }

  // Actions

  Future<void> likeStory(Story story, String uid) async {
    try {
      await _tables.createRow(
        databaseId: storyDatabaseId,
        tableId: likeTableId,
        rowId: ID.unique(),
        data: <String, dynamic>{'uId': uid, 'storyId': story.storyId},
      );
      await _tables.updateRow(
        databaseId: storyDatabaseId,
        tableId: storyTableId,
        rowId: story.storyId,
        data: <String, dynamic>{"likes": story.likesCount + 1},
      );
    } on AppwriteException catch (e) {
      throw StoriesFailure.unknown(e.message ?? 'Failed to like story');
    }
  }

  Future<void> unlikeStory(Story story, String uid) async {
    try {
      final likeDocs = await _tables.listRows(
        databaseId: storyDatabaseId,
        tableId: likeTableId,
        queries: [
          Query.and([
            Query.equal('uId', uid),
            Query.equal('storyId', story.storyId),
          ]),
        ],
      );
      if (likeDocs.rows.isNotEmpty) {
        await _tables.deleteRow(
          databaseId: storyDatabaseId,
          tableId: likeTableId,
          rowId: likeDocs.rows.first.$id,
        );
      }
      await _tables.updateRow(
        databaseId: storyDatabaseId,
        tableId: storyTableId,
        rowId: story.storyId,
        data: <String, dynamic>{"likes": story.likesCount - 1},
      );
    } on AppwriteException catch (e) {
      throw StoriesFailure.unknown(e.message ?? 'Failed to unlike story');
    }
  }

  // Builds a chapter from the picked files
  Future<Chapter> buildChapterFromFiles({
    required String title,
    required String description,
    required String coverImgPath,
    required String audioFilePath,
    required String lyricsFilePath,
  }) async {
    var lyrics = '';
    if (lyricsFilePath.isNotEmpty) {
      lyrics = await io.File(lyricsFilePath).readAsString();
    }
    return buildRecordedChapter(
      chapterId: ID.unique(),
      title: title,
      description: description,
      coverImgPath: coverImgPath,
      audioFilePath: audioFilePath,
      lyrics: lyrics,
    );
  }

  Future<Chapter> buildRecordedChapter({
    required String chapterId,
    required String title,
    required String description,
    required String coverImgPath,
    required String audioFilePath,
    required String lyrics,
  }) async {
    final metadata = readMetadata(io.File(audioFilePath));
    final playDuration = metadata.duration?.inMilliseconds ?? 0;
    final primaryColor = await _tintForCover(coverImgPath);
    return Chapter(
      chapterId: chapterId,
      title: title,
      coverImageUrl: coverImgPath,
      description: description,
      lyrics: lyrics,
      audioFileUrl: audioFilePath,
      playDuration: playDuration,
      tintColor: primaryColor,
    );
  }

  Future<void> createStory({
    required AuthUser user,
    required String title,
    required String description,
    required StoryCategory category,
    required String coverImgRef,
    required int storyPlayDuration,
    required List<Chapter> chapters,
  }) async {
    final storyId = ID.unique();
    var coverImgUrl = coverImgRef;
    Color primaryColor;

    if (!coverImgUrl.contains("http")) {
      primaryColor = await _tintForCover(coverImgUrl);
      coverImgUrl = await _uploadFile(
        fileId: storyId,
        filePath: coverImgRef,
        what: "story cover",
      );
    } else {
      primaryColor = const Color(0xffcbc6c6);
    }

    await pushChaptersToStory(chapters, storyId);

    try {
      await _tables.createRow(
        databaseId: storyDatabaseId,
        tableId: storyTableId,
        rowId: storyId,
        data: <String, dynamic>{
          'title': title,
          'description': description,
          'category': category.name,
          'coverImgUrl': coverImgUrl,
          'creatorId': user.uid,
          'creatorName': user.displayName,
          'creatorImgUrl': user.profileImageUrl,
          'likes': 0,
          'playDuration': storyPlayDuration,
          'tintColor': _colorToHex(primaryColor),
        },
      );
    } on AppwriteException catch (e) {
      log('Failed to create story row: ${e.message}');
      throw StoriesFailure.unknown(e.message ?? 'Failed to create story');
    }

    // Notify followers
    if (user.followers.isNotEmpty) {
      try {
        await _functions.createExecution(
          functionId: sendStoryNotificationFunctionID,
          body: json.encode({
            'creatorId': user.uid,
            'payload': {
              'title': 'New story added!',
              'body':
                  "A new story was just added by ${user.displayName}: $title",
            },
          }),
        );
      } catch (e) {
        log('Failed to send story notification: $e');
      }
    }
  }

  Future<void> pushChaptersToStory(
    List<Chapter> chapters,
    String storyId,
  ) async {
    for (final chapter in chapters) {
      var coverImgUrl = chapter.coverImageUrl;
      if (!coverImgUrl.contains("http")) {
        coverImgUrl = await _uploadFile(
          fileId: chapter.chapterId,
          filePath: coverImgUrl,
          what: "chapter cover",
        );
      }

      final audioFileUrl = await _uploadFile(
        fileId: 'audioFor${chapter.chapterId}',
        filePath: chapter.audioFileUrl,
        what: "audio file",
      );

      final chapterData = <String, dynamic>{
        'title': chapter.title,
        'description': chapter.description,
        'coverImgUrl': coverImgUrl,
        'lyrics': chapter.lyrics,
        'playDuration': chapter.playDuration,
        'tintColor': _colorToHex(chapter.tintColor),
        'storyId': storyId,
        'audioFileUrl': audioFileUrl,
      };

      try {
        await _tables.createRow(
          databaseId: storyDatabaseId,
          tableId: chapterTableId,
          rowId: chapter.chapterId,
          data: chapterData,
        );
      } on AppwriteException catch (e) {
        if (e.code == 409) {
          log("Chapter row '${chapter.chapterId}' already exists; updating it");
          await _tables.updateRow(
            databaseId: storyDatabaseId,
            tableId: chapterTableId,
            rowId: chapter.chapterId,
            data: chapterData,
          );
        } else {
          rethrow;
        }
      }
    }
  }

  Future<void> addChaptersToStory(
    List<Chapter> chapters,
    String storyId,
  ) async {
    await pushChaptersToStory(chapters, storyId);
    try {
      final all = await fetchChaptersForStory(storyId);
      final total = all.fold(0, (sum, c) => sum + c.playDuration);
      await _tables.updateRow(
        databaseId: storyDatabaseId,
        tableId: storyTableId,
        rowId: storyId,
        data: <String, dynamic>{"playDuration": total},
      );
    } on AppwriteException catch (e) {
      log("Failed to update story duration: ${e.message}");
    }
  }

  Future<void> deleteStory(Story story) async {
    try {
      await _storage.deleteFile(bucketId: storyBucketId, fileId: story.storyId);
    } on AppwriteException catch (e) {
      log('Failed to delete story cover image: ${e.message}');
    }

    // Deleting the live chapters from the DB
    try {
      final chapters = await fetchChaptersForStory(story.storyId);
      for (final chapter in chapters) {
        await deleteChapter(chapter);
      }
    } on AppwriteException catch (e) {
      log('Failed to delete story chapters: ${e.message}');
    }

    try {
      await _deleteAllStoryLikes(story.storyId);
    } on AppwriteException catch (e) {
      log('Failed to delete story likes: ${e.message}');
    }

    try {
      await _tables.deleteRow(
        databaseId: storyDatabaseId,
        tableId: storyTableId,
        rowId: story.storyId,
      );
    } on AppwriteException catch (e) {
      throw StoriesFailure.unknown(e.message ?? 'Failed to delete story');
    }
  }

  Future<void> deleteChapter(Chapter chapter) async {
    try {
      await _storage.deleteFile(
        bucketId: storyBucketId,
        fileId: chapter.chapterId,
      );
    } on AppwriteException catch (e) {
      log("Failed to delete chapter cover image: ${e.message}");
    }
    try {
      await _storage.deleteFile(
        bucketId: storyBucketId,
        fileId: 'audioFor${chapter.chapterId}',
      );
    } on AppwriteException catch (e) {
      log("Failed to delete chapter audio file: ${e.message}");
    }
    try {
      await _tables.deleteRow(
        databaseId: storyDatabaseId,
        tableId: chapterTableId,
        rowId: chapter.chapterId,
      );
    } on AppwriteException catch (e) {
      log("Failed to delete chapter document: ${e.message}");
    }
  }

  Future<void> _deleteAllStoryLikes(String storyId) async {
    final likeDocs = await _tables.listRows(
      databaseId: storyDatabaseId,
      tableId: likeTableId,
      queries: [Query.equal('storyId', storyId)],
    );
    for (final like in likeDocs.rows) {
      await _tables.deleteRow(
        databaseId: storyDatabaseId,
        tableId: likeTableId,
        rowId: like.$id,
      );
    }
  }

  // Helpers

  Future<String> _uploadFile({
    required String fileId,
    required String filePath,
    required String what,
  }) async {
    try {
      await _storage.createFile(
        bucketId: storyBucketId,
        fileId: fileId,
        file: InputFile.fromPath(path: filePath),
      );
    } on AppwriteException catch (e) {
      // if user tries uploading same file then reuse
      if (e.code == 409 || e.type == 'storage_file_already_exists') {
        log("File '$fileId' already exists ($what); reusing it");
      } else {
        log("Failed to upload $what: ${e.message}");
        throw StoriesFailure.upload(what);
      }
    }
    return "$appwriteEndpoint/storage/buckets/$storyBucketId/files/$fileId/view?project=$appwriteProjectId";
  }

  Future<Color> _tintForCover(String coverPath) async {
    if (coverPath.contains('http')) return const Color(0xffcbc6c6);
    final scheme = await ColorScheme.fromImageProvider(
      provider: FileImage(io.File(coverPath)),
    );
    return scheme.primary;
  }

  List<Story> _rowsToStories(List<Row> rows, String currentUid) {
    final stories = <Story>[];
    for (final row in rows) {
      try {
        stories.add(
          _storyFromMap(row.data, row.$id, row.$createdAt, currentUid),
        );
      } catch (e) {
        // Skiping malformed story rows
        log('Skipping malformed story row ${row.$id}: $e');
      }
    }
    return stories;
  }

  List<Story> _meiliHitsToStories(
    List<Map<String, dynamic>> hits,
    String currentUid,
  ) {
    final stories = <Story>[];
    for (final hit in hits) {
      try {
        stories.add(
          _storyFromMap(hit, hit['\$id'], hit['\$createdAt'], currentUid),
        );
      } catch (e) {
        log('Skipping malformed meilisearch story hit: $e');
      }
    }
    return stories;
  }

  Story _storyFromMap(
    Map<String, dynamic> data,
    String id,
    String createdAt,
    String currentUid,
  ) {
    return Story(
      title: data['title'],
      storyId: id,
      description: data['description'],
      userIsCreator: data['creatorId'] == currentUid,
      category: StoryCategory.values.byName(data['category']),
      coverImageUrl: data['coverImgUrl'],
      creatorId: data['creatorId'],
      creatorName: data['creatorName'],
      creatorImgUrl: data['creatorImgUrl'],
      creationDate: DateTime.parse(createdAt),
      likesCount: data['likes'],
      isLikedByCurrentUser: false,
      playDuration: data['playDuration'],
      tintColor: Color(int.parse("0xff${data['tintColor']}")),
    );
  }

  ResonateUser _rowToUser(Map<String, dynamic> data, String id) {
    final userData = Map<String, dynamic>.from(data);
    userData['docId'] = id;
    userData['uid'] = id;
    userData['userName'] = userData['username'];
    final ratingCount = (userData['ratingCount'] ?? 0) as num;
    userData['userRating'] = ratingCount == 0
        ? 0
        : userData['ratingTotal'] / ratingCount;
    return ResonateUser.fromJson(userData);
  }

  ResonateUser _meiliHitToUser(Map<String, dynamic> hit) =>
      _rowToUser(hit, hit['\$id']);

  String _colorToHex(Color color) =>
      '${(color.a * 255).toInt().toRadixString(16).padLeft(2, '0')}'
      '${(color.r * 255).toInt().toRadixString(16).padLeft(2, '0')}'
      '${(color.g * 255).toInt().toRadixString(16).padLeft(2, '0')}'
      '${(color.b * 255).toInt().toRadixString(16).padLeft(2, '0')}';
}
