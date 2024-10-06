import 'dart:ui';

class Chapter {
  final String title;
  final String coverImageUrl;
  final String description;
  final String lyrics;
  final String mp3FileUrl;
  final Duration playDuration;
  final Color tintColor;

  Chapter(this.title, this.coverImageUrl, this.description, this.lyrics,
      this.mp3FileUrl, this.playDuration, this.tintColor);
}
