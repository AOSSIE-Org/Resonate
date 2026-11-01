import 'package:audioplayers/audioplayers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/chapter_audio.g.dart';

// Wraps the audio SDK so the chapter view model can drive playback without importing audioplayers
class ChapterAudio {
  ChapterAudio(this._player);

  final AudioPlayer _player;

  Stream<Duration> get positionChanges => _player.onPositionChanged;

  Stream<bool> get playingChanges =>
      _player.onPlayerStateChanged.map((s) => s == PlayerState.playing);

  Future<void> load(String url) => _player.setSourceUrl(url);

  Future<void> play() => _player.resume();

  Future<void> pause() => _player.pause();

  Future<void> seek(Duration position) => _player.seek(position);

  Future<void> release() => _player.release();
}

typedef ChapterAudioFactory = ChapterAudio Function();

@Riverpod(keepAlive: true)
ChapterAudioFactory chapterAudioFactory(Ref ref) =>
    () => ChapterAudio(AudioPlayer()..setReleaseMode(ReleaseMode.stop));
