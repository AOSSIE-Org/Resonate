import 'dart:developer';
import 'dart:ui';

import 'package:appwrite/models.dart';
import 'package:resonate/features/stories/model/story.dart';
import 'package:resonate/utils/enums/story_category.dart';

/// Single source for mapping Appwrite story rows / search hits onto [Story],
/// shared by the stories and profile repositories.
///
/// Pass [currentUid] to mark stories the viewer created; omit it to always
/// map `userIsCreator` as false (the profile page's existing behavior).
Story storyFromMap(
  Map<String, dynamic> data, {
  required String id,
  required String createdAt,
  String? currentUid,
}) {
  return Story(
    title: data['title'],
    storyId: id,
    description: data['description'],
    userIsCreator: currentUid != null && data['creatorId'] == currentUid,
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

/// Maps rows onto [Story], skipping malformed rows (missing user rows and
/// partially backfilled data are a known backend condition).
List<Story> rowsToStories(List<Row> rows, {String? currentUid}) {
  final stories = <Story>[];
  for (final row in rows) {
    try {
      stories.add(
        storyFromMap(
          row.data,
          id: row.$id,
          createdAt: row.$createdAt,
          currentUid: currentUid,
        ),
      );
    } catch (e) {
      log('Skipping malformed story row ${row.$id}: $e');
    }
  }
  return stories;
}
