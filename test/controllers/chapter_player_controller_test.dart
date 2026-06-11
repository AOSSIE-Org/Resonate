import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/chapter_player_controller.dart';

void main() {
  ChapterPlayerController chapterPlayerController = ChapterPlayerController();
  test('check initial values', () {
    expect(chapterPlayerController.currentPage.value, 0.0);
    expect(chapterPlayerController.sliderProgress.value, 0.0);
    expect(chapterPlayerController.isPlaying.value, false);
    expect(chapterPlayerController.lyricController.lyricNotifier.value, null);
  });

  testWidgets('check initialize', (WidgetTester tester) async {
    await tester.pumpWidget(GetMaterialApp(home: Container()));
    await tester.pumpAndSettle();
    chapterPlayerController.initialize(
      AudioPlayer(),
      '[00:01.00] Hello world',
      Duration(minutes: 3),
    );

    expect(
      chapterPlayerController.lyricController.lyricNotifier.value,
      isNotNull,
    );
    expect(chapterPlayerController.audioPlayer, isA<AudioPlayer>());
    expect(chapterPlayerController.audioPlayer?.releaseMode, ReleaseMode.stop);
    expect(chapterPlayerController.chapterDuration.inMinutes, 3);
  });

  testWidgets('check togglePlayPause', (WidgetTester tester) async {
    await tester.pumpWidget(GetMaterialApp(home: Container()));
    await tester.pumpAndSettle();
    chapterPlayerController.initialize(
      AudioPlayer(),
      '[00:01.00] Hello world',
      Duration(minutes: 3),
    );

    expect(chapterPlayerController.isPlaying.value, false);
    chapterPlayerController.togglePlayPause();
    expect(chapterPlayerController.isPlaying.value, true);
  });
}
