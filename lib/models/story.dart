import 'dart:ui';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:resonate/models/chapter.dart';
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
  String totalMin;
  Color tintColor;
  List<Chapter> chapters;

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
    required this.totalMin,
    required this.tintColor,
    required this.chapters,
  })  : likesCount = likesCount.obs, // Observable
        isLikedByCurrentUser = isLikedByCurrentUser.obs; // Observable
}
