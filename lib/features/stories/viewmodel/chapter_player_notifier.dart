import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_lyric/flutter_lyric.dart';
import 'package:resonate/features/stories/model/chapter_player_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/chapter_player_notifier.g.dart';

@riverpod
class ChapterPlayer extends _$ChapterPlayer {
  AudioPlayer? _player;
  final LyricController _lyricController = LyricController();
  Duration _chapterDuration = Duration.zero;

  LyricController get lyricController => _lyricController;
  Duration get chapterDuration => _chapterDuration;

  @override
  ChapterPlayerState build(String chapterId) {
    ref.onDispose(() {
      _player?.release();
      _lyricController.dispose();
    });
    return const ChapterPlayerState();
  }

  void initialize({
    required String audioUrl,
    required String lyrics,
    required Duration duration,
  }) {
    _chapterDuration = duration;
    _lyricController.loadLyric(lyrics);

    final player = AudioPlayer()..setReleaseMode(ReleaseMode.stop);
    _player = player;
    player.setSourceUrl(audioUrl);

    _lyricController.setOnTapLineCallback((start) => player.seek(start));

    player.onPositionChanged.listen((event) {
      if (!ref.mounted) return;
      state = state.copyWith(sliderProgress: event.inMilliseconds.toDouble());
      _lyricController.setProgress(event);
    });
    player.onPlayerStateChanged.listen((s) {
      if (!ref.mounted) return;
      state = state.copyWith(isPlaying: s == PlayerState.playing);
    });
  }

  void togglePlayPause() {
    if (state.isPlaying) {
      _player?.pause();
    } else {
      _player?.resume();
    }
  }

  void seek(Duration position) => _player?.seek(position);

  void onSliderChanged(double value) =>
      state = state.copyWith(sliderProgress: value);

  void onSliderChangeEnd(double value) {
    final position = Duration(milliseconds: value.toInt());
    _lyricController.setProgress(position);
    _player?.seek(position);
  }
}
