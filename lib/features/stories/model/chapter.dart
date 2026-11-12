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

  const Chapter({
    required this.chapterId,
    required this.title,
    required this.coverImageUrl,
    required this.description,
    required this.lyrics,
    required this.audioFileUrl,
    required this.playDuration,
    required this.tintColor,
  });
}
