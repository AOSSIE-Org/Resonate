import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

import 'package:resonate/features/stories/data/services/recording_audio.dart';
import 'package:resonate/features/stories/model/recorded_chapter.dart';
import 'package:resonate/features/stories/model/recording_playback_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/recording_playback.g.dart';

// Playback of the on-device recordings
@Riverpod(keepAlive: true)
class RecordingPlayback extends _$RecordingPlayback {
  final _subscriptions = <StreamSubscription<void>>[];

  @override
  RecordingPlaybackState build() {
    ref.onDispose(_cancel);
    return const RecordingPlaybackState();
  }

  Future<void> toggle(RecordedChapter chapter) async {
    final audio = ref.read(recordingAudioPlayerProvider);
    if (state.chapterId != chapter.id) {
      await _load(chapter, audio);
    }
    if (state.isPlaying) {
      await audio.pause();
      if (ref.mounted) state = state.copyWith(isPlaying: false);
      return;
    }
    await audio.resume();
    if (ref.mounted) state = state.copyWith(isPlaying: true);
  }

  Future<void> seek(Duration position) async {
    if (state.chapterId == null) return;
    await ref.read(recordingAudioPlayerProvider).seek(position);
    if (ref.mounted) state = state.copyWith(position: position);
  }

  Future<void> stop() async {
    if (state.chapterId == null) return;
    final audio = ref.read(recordingAudioPlayerProvider);
    await _cancel();
    await audio.stop();
    if (ref.mounted) state = const RecordingPlaybackState();
  }

  Future<void> _load(RecordedChapter chapter, AudioPlayer audio) async {
    await _cancel();
    await audio.setSourceDeviceFile(chapter.audioFilePath);
    state = RecordingPlaybackState(
      chapterId: chapter.id,
      duration: Duration(milliseconds: chapter.durationMs),
    );
    _subscriptions.addAll([
      audio.onPositionChanged.listen((position) {
        if (ref.mounted) state = state.copyWith(position: position);
      }),
      audio.onDurationChanged.listen((duration) {
        if (ref.mounted) state = state.copyWith(duration: duration);
      }),
      audio.onPlayerComplete.listen((_) {
        if (!ref.mounted) return;
        state = state.copyWith(isPlaying: false, position: Duration.zero);
      }),
    ]);
  }

  Future<void> _cancel() async {
    final pending = List.of(_subscriptions);
    _subscriptions.clear();
    for (final subscription in pending) {
      await subscription.cancel();
    }
  }
}
