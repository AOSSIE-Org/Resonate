import 'dart:developer';
import 'dart:ui';

import 'package:appwrite/models.dart';
import 'package:resonate/utils/enums/story_category.dart';

class Story {
  final String title;
  final bool userIsCreator;
  final String storyId;
  final String description;
  final StoryCategory category;
  final String coverImageUrl;
  final String creatorId;
  final String creatorName;
  final String creatorImgUrl;
  final DateTime creationDate;
  final int likesCount;
  final bool isLikedByCurrentUser;
  final int playDuration;
  final Color tintColor;

  const Story({
    required this.title,
    required this.storyId,
    required this.description,
    required this.userIsCreator,
    required this.category,
    required this.coverImageUrl,
    required this.creatorId,
    required this.creatorName,
    required this.creatorImgUrl,
    required this.creationDate,
    required this.likesCount,
    required this.isLikedByCurrentUser,
    required this.playDuration,
    required this.tintColor,
  });

  factory Story.fromMap(
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

  // Maps rows onto Story, skipping malformed rows
  static List<Story> fromRows(List<Row> rows, {String? currentUid}) {
    final stories = <Story>[];
    for (final row in rows) {
      try {
        stories.add(
          Story.fromMap(
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

  Story copyWith({
    int? likesCount,
    bool? isLikedByCurrentUser,
    int? playDuration,
  }) => Story(
    title: title,
    storyId: storyId,
    description: description,
    userIsCreator: userIsCreator,
    category: category,
    coverImageUrl: coverImageUrl,
    creatorId: creatorId,
    creatorName: creatorName,
    creatorImgUrl: creatorImgUrl,
    creationDate: creationDate,
    likesCount: likesCount ?? this.likesCount,
    isLikedByCurrentUser: isLikedByCurrentUser ?? this.isLikedByCurrentUser,
    playDuration: playDuration ?? this.playDuration,
    tintColor: tintColor,
  );
}
