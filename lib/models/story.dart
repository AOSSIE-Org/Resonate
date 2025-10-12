import 'dart:ui';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:resonate/models/chapter.dart';
import 'package:resonate/models/live_chapter_model.dart';
import 'package:resonate/utils/enums/story_category.dart';

class Story {
  final String title;
  bool userIsCreator;
  final String storyId;
  String description;
  StoryCategory category;
  String coverImageUrl;
  String creatorId;
  String creatorName;
  String creatorImgUrl;
  final DateTime creationDate;
  RxInt likesCount; // Changed to RxInt
  RxBool isLikedByCurrentUser; // Changed to RxBool
  int playDuration;
  Color tintColor;
  List<Chapter> chapters;
  LiveChapterModel? liveChapter;

  Story({
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
    required int likesCount, // Normal int for constructor
    required bool isLikedByCurrentUser, // Normal bool for constructor
    required this.playDuration,
    required this.tintColor,
    required this.chapters,
    this.liveChapter,
  }) : likesCount = likesCount.obs, // Observable
       isLikedByCurrentUser = isLikedByCurrentUser.obs; // Observable
}
