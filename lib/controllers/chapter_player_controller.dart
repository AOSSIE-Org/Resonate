import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_lyric/lyrics_reader_model.dart';

class ChapterPlayerController extends GetxController {
  Rx<int> currentPage = 0.obs;
  Rx<int> lyricProgress = 0.obs;
  Rx<double> sliderProgress = 0.0.obs;
  Rx<bool> isPlaying = false.obs;
  AudioPlayer? audioPlayer;
  late Duration chapterDuration;
  late LyricsReaderModel lyricModel;

  void initialize(
      AudioPlayer player, LyricsReaderModel model, Duration duration) {
    audioPlayer = player;
    lyricModel = model;
    chapterDuration = duration;
    audioPlayer?.setReleaseMode(ReleaseMode.stop);

    audioPlayer?.onPositionChanged.listen((Duration event) {
      sliderProgress.value = event.inMilliseconds.toDouble();
      lyricProgress.value = event.inMilliseconds;
    });

    audioPlayer?.onPlayerStateChanged.listen((PlayerState state) {
      isPlaying.value = state == PlayerState.playing;
    });
  }

  void togglePlayPause() {
    if (isPlaying.value) {
      audioPlayer?.pause();
    } else {
      audioPlayer?.resume();
    }
    isPlaying.value = !isPlaying.value;
  }

  @override
  void onClose() {
    audioPlayer?.release();
    super.onClose();
  }
}
