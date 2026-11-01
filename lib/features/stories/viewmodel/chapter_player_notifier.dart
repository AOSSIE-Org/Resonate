import 'dart:async';

import 'package:flutter_lyric/flutter_lyric.dart';
import 'package:resonate/features/stories/data/services/chapter_audio.dart';
import 'package:resonate/features/stories/model/chapter_player_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/chapter_player_notifier.g.dart';

@riverpod
class ChapterPlayer extends _$ChapterPlayer {
  ChapterAudio? _audio;
  final LyricController _lyricController = LyricController();
  final _subscriptions = <StreamSubscription<void>>[];
  Duration _chapterDuration = Duration.zero;

  LyricController get lyricController => _lyricController;
  Duration get chapterDuration => _chapterDuration;

  @override
  ChapterPlayerState build(String chapterId) {
    ref.onDispose(() {
      for (final subscription in _subscriptions) {
        unawaited(subscription.cancel());
      }
      _subscriptions.clear();
      unawaited(_audio?.release());
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
    _lyricController.load(lyrics);

    final audio = ref.read(chapterAudioFactoryProvider)();
    _audio = audio;
    unawaited(audio.load(audioUrl));

    _subscriptions.addAll([
      audio.positionChanges.listen((position) {
        if (!ref.mounted) return;
        state = state.copyWith(
          sliderProgress: position.inMilliseconds.toDouble(),
        );
        _lyricController.setPosition(position);
      }),
      audio.playingChanges.listen((isPlaying) {
        if (!ref.mounted) return;
        state = state.copyWith(isPlaying: isPlaying);
      }),
    ]);
  }

  void togglePlayPause() {
    if (state.isPlaying) {
      unawaited(_audio?.pause());
    } else {
      unawaited(_audio?.play());
    }
  }

  void seek(Duration position) => unawaited(_audio?.seek(position));

  void onSliderChanged(double value) =>
      state = state.copyWith(sliderProgress: value);

  void onSliderChangeEnd(double value) {
    final position = Duration(milliseconds: value.toInt());
    _lyricController.setPosition(position);
    unawaited(_audio?.seek(position));
  }
}
