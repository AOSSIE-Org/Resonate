import 'dart:ui';

import 'package:resonate/features/stories/model/chapter.dart';
import 'package:resonate/features/stories/model/live_chapter_model.dart';
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
  final List<Chapter> chapters;
  final LiveChapterModel? liveChapter;

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
    required this.chapters,
    this.liveChapter,
  });

  Story copyWith({
    int? likesCount,
    bool? isLikedByCurrentUser,
    int? playDuration,
    List<Chapter>? chapters,
    LiveChapterModel? liveChapter,
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
    chapters: chapters ?? this.chapters,
    liveChapter: liveChapter ?? this.liveChapter,
  );
}
