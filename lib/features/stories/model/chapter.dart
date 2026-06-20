import 'dart:ui';

class Chapter {
  final String chapterId;
  final String title;
  final String coverImageUrl;
  final String description;
  final String lyrics;
  final String audioFileUrl;
  final int playDuration;
  final Color tintColor;

  const Chapter(
    this.chapterId,
    this.title,
    this.coverImageUrl,
    this.description,
    this.lyrics,
    this.audioFileUrl,
    this.playDuration,
    this.tintColor,
  );
}
