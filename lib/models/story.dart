import 'dart:ui';

import 'package:resonate/models/chapter.dart';
import 'package:resonate/utils/enums/story_category.dart';

class Story {
  final String title;
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
  final Duration totalMin;
  final Color tintColor;
  final List<Chapter> chapters;
  Story(
      this.title,
      this.storyId,
      this.description,
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
