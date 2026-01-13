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

  RxDouble playbackSpeed = 1.0.obs;

  // Sleep Timer
  Timer? _sleepTimer;
  Rxn<int> sleepTimerRemaining = Rxn<int>(); // Seconds remaining

  void initialize(
    AudioPlayer player,
    LyricsReaderModel model,
    Duration duration,
  ) {
    audioPlayer = player;
    lyricModel = model;
    chapterDuration = duration;
    audioPlayer?.setReleaseMode(ReleaseMode.stop);
    
    // Set default playback speed
    audioPlayer?.setPlaybackRate(playbackSpeed.value);
    audioPlayer?.setVolume(1.0);

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
      // If we pause manually, should we cancel the timer? 
      // Usually sleep timers keep running or pause? 
      // Let's keep it running to be simple, or maybe cancel?
      // Better: Keep running, but if it hits 0 it just stops. 
      // Actually, standard behavior: timer counts down valid "play time"? 
      // No, usually it's "wall clock time".
      // If I pause and play again, volume should be restored if it was fading.
      audioPlayer?.setVolume(1.0); 
    } else {
      // Ensure volume is up if we resume
      audioPlayer?.setVolume(1.0);
      audioPlayer?.resume();
    }
    isPlaying.value = !isPlaying.value;
  }

  void setPlaybackSpeed(double speed) {
    playbackSpeed.value = speed;
    audioPlayer?.setPlaybackRate(speed);
  }

  void startSleepTimer(int minutes) {
    cancelSleepTimer();
    sleepTimerRemaining.value = minutes * 60;
    
    _sleepTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (sleepTimerRemaining.value != null && sleepTimerRemaining.value! > 0) {
        sleepTimerRemaining.value = sleepTimerRemaining.value! - 1;
        
        // Zen Fade Out Logic: Start fading in last 60 seconds
        if (sleepTimerRemaining.value! <= 60 && isPlaying.value) {
          double vol = sleepTimerRemaining.value! / 60.0;
          if (vol < 0) vol = 0;
          audioPlayer?.setVolume(vol);
        }
      } else {
        // Time's up
        audioPlayer?.pause();
        audioPlayer?.setVolume(1.0); // Reset for next time
        isPlaying.value = false;
        cancelSleepTimer();
      }
    });
  }

  void cancelSleepTimer() {
    _sleepTimer?.cancel();
    _sleepTimer = null;
    sleepTimerRemaining.value = null;
    audioPlayer?.setVolume(1.0); // Ensure full volume
  }

  @override
  void onClose() {
    _sleepTimer?.cancel();
    audioPlayer?.release();
    super.onClose();
  }
}
