import 'dart:ui';

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
  int likesCount;
  bool isLikedByCurrentUser;
  String totalMin;
  Color tintColor;
  List<Chapter> chapters;
  Story(
      this.title,
      this.storyId,
      this.description,
      this.userIsCreator,
      this.category,
      this.coverImageUrl,
      this.creatorId,
      this.creatorName,
      this.creatorImgUrl,
      this.creationDate,
      this.likesCount,
      this.isLikedByCurrentUser,
      this.totalMin,
      this.tintColor,
      this.chapters);
}
