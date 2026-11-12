import 'package:audioplayers/audioplayers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/recording_audio.g.dart';

@Riverpod(keepAlive: true)
AudioPlayer recordingAudioPlayer(Ref ref) {
  final player = AudioPlayer()..setReleaseMode(ReleaseMode.stop);
  ref.onDispose(player.dispose);
  return player;
}
