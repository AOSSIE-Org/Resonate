import 'dart:async';
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



  Timer? _sleepTimer;
  Rxn<int> sleepTimerRemaining = Rxn<int>();

  void initialize(
    AudioPlayer player,
    LyricsReaderModel model,
    Duration duration,
  ) {
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
      audioPlayer?.setVolume(1.0); 
    } else {
      audioPlayer?.setVolume(1.0);
      audioPlayer?.resume();
    }
    isPlaying.value = !isPlaying.value;
  }



  void startSleepTimer(int minutes) {
    cancelSleepTimer();
    sleepTimerRemaining.value = minutes * 60;
    
    _sleepTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (sleepTimerRemaining.value != null && sleepTimerRemaining.value! > 0) {
        sleepTimerRemaining.value = sleepTimerRemaining.value! - 1;
        
        if (sleepTimerRemaining.value! <= 60 && isPlaying.value) {
          double vol = sleepTimerRemaining.value! / 60.0;
          if (vol < 0) vol = 0;
          audioPlayer?.setVolume(vol);
        }
      } else {
        audioPlayer?.pause();
        audioPlayer?.setVolume(1.0);
        isPlaying.value = false;
        cancelSleepTimer();
      }
    });
  }

  void cancelSleepTimer() {
    _sleepTimer?.cancel();
    _sleepTimer = null;
    sleepTimerRemaining.value = null;
    sleepTimerRemaining.value = null;
    audioPlayer?.setVolume(1.0);
  }

  @override
  void onClose() {
    _sleepTimer?.cancel();
    audioPlayer?.release();
    super.onClose();
  }
}
