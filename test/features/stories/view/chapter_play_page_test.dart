import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_lyric/flutter_lyric.dart';
import 'package:resonate/features/stories/model/chapter.dart';
import 'package:resonate/features/stories/model/chapter_player_state.dart';
import 'package:resonate/features/stories/view/pages/chapter_play_page.dart';
import 'package:resonate/features/stories/viewmodel/chapter_player_notifier.dart';

import 'stories_test_helpers.dart';


class _StubChapterPlayer extends ChapterPlayer {
  _StubChapterPlayer(this._state);

  final ChapterPlayerState _state;

  ({String audioUrl, String lyrics, Duration duration})? initializedWith;
  int toggleCount = 0;
  final List<Duration> seeks = [];
  final List<double> sliderChanges = [];

  @override
  ChapterPlayerState build(String chapterId) => _state;

  @override
  void initialize({
    required String audioUrl,
    required String lyrics,
    required Duration duration,
  }) {
    initializedWith = (audioUrl: audioUrl, lyrics: lyrics, duration: duration);
    lyricController.load(lyrics);
  }

  // The real notifier stores this during initialize; the slider's max reads
  // from it, and a zero max makes any progress value out of range.
  @override
  Duration get chapterDuration => initializedWith?.duration ?? Duration.zero;

  @override
  void togglePlayPause() => toggleCount++;

  @override
  void seek(Duration position) => seeks.add(position);

  @override
  void onSliderChanged(double value) => sliderChanges.add(value);
}

Chapter buildChapter({
  String id = 'c1',
  String title = 'Chapter One',
  String description = 'How it begins',
  String lyrics = '',
  int playDuration = 65000,
}) => Chapter(
  chapterId: id,
  title: title,
  coverImageUrl: 'https://example.com/cover.jpg',
  description: description,
  lyrics: lyrics,
  audioFileUrl: 'https://example.com/audio.mp3',
  playDuration: playDuration,
  tintColor: const Color(0xff336699),
);

const _lrc = '[00:01.00]first line\n[00:05.00]second line';

void main() {
  late _StubChapterPlayer player;

  Future<void> pumpPlayPage(
    WidgetTester tester, {
    Chapter? chapter,
    ChapterPlayerState state = const ChapterPlayerState(),
  }) async {
    final target = chapter ?? buildChapter();
    player = _StubChapterPlayer(state);
    await pumpStoriesPage(
      tester,
      ChapterPlayPage(chapter: target),
      overrides: [
        chapterPlayerProvider(target.chapterId).overrideWith(() => player),
      ],
    );
    await tester.pumpAndSettle();
  }

  group('opening a chapter', () {
    testStoryWidget('hands the audio and lyrics to the player', (tester) async {
      await pumpPlayPage(
        tester,
        chapter: buildChapter(lyrics: _lrc, playDuration: 65000),
      );

      expect(player.initializedWith?.audioUrl, 'https://example.com/audio.mp3');
      expect(player.initializedWith?.lyrics, _lrc);
      expect(
        player.initializedWith?.duration,
        const Duration(milliseconds: 65000),
      );
    });

    testStoryWidget('shows the chapter title and description', (tester) async {
      await pumpPlayPage(
        tester,
        chapter: buildChapter(
          title: 'A Loud Night',
          description: 'What happened next',
        ),
      );

      expect(find.text('A Loud Night'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);
      expect(find.text('What happened next'), findsOneWidget);
    });
  });

  group('lyrics', () {
    // A recorded chapter whose transcription failed has none; the panel must
    // say so rather than render an empty scroller.
    testStoryWidget('say so when the chapter has none', (tester) async {
      await pumpPlayPage(tester, chapter: buildChapter(lyrics: ''));

      expect(find.text('No lyrics'), findsOneWidget);
      expect(find.byType(LyricView), findsNothing);
    });

    testStoryWidget('whitespace-only lyrics count as none', (tester) async {
      await pumpPlayPage(tester, chapter: buildChapter(lyrics: '   \n  '));

      expect(find.text('No lyrics'), findsOneWidget);
    });

    testStoryWidget('render a lyric view when the chapter has them', (
      tester,
    ) async {
      await pumpPlayPage(tester, chapter: buildChapter(lyrics: _lrc));

      expect(find.byType(LyricView), findsOneWidget);
      expect(find.text('No lyrics'), findsNothing);
    });
  });

  group('the player controls', () {
    // The header renders a collapsed and an expanded control, so each icon
    // legitimately appears twice.
    testStoryWidget('start on the play icon', (tester) async {
      await pumpPlayPage(tester);

      expect(find.byIcon(Icons.play_arrow), findsWidgets);
      expect(find.byIcon(Icons.pause), findsNothing);
    });

    testStoryWidget('show pause while the chapter is playing', (tester) async {
      await pumpPlayPage(
        tester,
        state: const ChapterPlayerState(isPlaying: true),
      );

      expect(find.byIcon(Icons.pause), findsWidgets);
    });

    testStoryWidget('tapping play asks the player to toggle', (tester) async {
      await pumpPlayPage(tester);

      await tester.tap(find.byIcon(Icons.play_arrow).first);
      await tester.pumpAndSettle();

      expect(player.toggleCount, 1);
    });

    testStoryWidget('offer a seek slider across the chapter', (tester) async {
      await pumpPlayPage(tester, chapter: buildChapter(playDuration: 65000));

      expect(find.byType(Slider), findsOneWidget);
      final slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.value, 0.0);
    });

    testStoryWidget('reflect progress already made', (tester) async {
      await pumpPlayPage(
        tester,
        state: const ChapterPlayerState(sliderProgress: 30000),
      );

      expect(tester.widget<Slider>(find.byType(Slider)).value, 30000);
    });

    testStoryWidget('survive a position past the stored duration', (
      tester,
    ) async {
      await pumpPlayPage(
        tester,
        chapter: buildChapter(playDuration: 65000),
        state: const ChapterPlayerState(sliderProgress: 99000),
      );

      expect(tester.takeException(), isNull);
      final slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.value, slider.max);
    });

    testStoryWidget('survive a chapter with no stored duration', (
      tester,
    ) async {
      await pumpPlayPage(
        tester,
        chapter: buildChapter(playDuration: 0),
        state: const ChapterPlayerState(sliderProgress: 12000),
      );

      expect(tester.takeException(), isNull);
      final slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.value, slider.max);
    });
  });
}
