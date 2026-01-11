import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lyric/lyrics_reader_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/chapter_player_controller.dart';

void main() {
  ChapterPlayerController chapterPlayerController = ChapterPlayerController();

  testWidgets('check setPlaybackSpeed', (WidgetTester tester) async {
    await tester.pumpWidget(GetMaterialApp(home: Container()));
    await tester.pumpAndSettle();
    
    chapterPlayerController.initialize(
      AudioPlayer(),
      LyricsReaderModel(),
      Duration(minutes: 3),
    );

    // Initial check
    expect(chapterPlayerController.playbackSpeed.value, 1.0);

    // Change speed
    chapterPlayerController.setPlaybackSpeed(1.5);
    expect(chapterPlayerController.playbackSpeed.value, 1.5);
    
    chapterPlayerController.setPlaybackSpeed(0.5);
    expect(chapterPlayerController.playbackSpeed.value, 0.5);
    
    chapterPlayerController.setPlaybackSpeed(2.0);
    expect(chapterPlayerController.playbackSpeed.value, 2.0);
  });
}
