import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_lyric/lyrics_reader_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/controllers/chapter_player_controller.dart';

// Manual Mock if needed, or use Mockito if we can't run codegen
class MockAudioPlayer extends Mock implements AudioPlayer {
  @override
  Future<void> setVolume(double? volume) => super.noSuchMethod(
        Invocation.method(#setVolume, [volume]),
        returnValue: Future.value(),
        returnValueForMissingStub: Future.value(),
      );

  @override
  Future<void> pause() => super.noSuchMethod(
        Invocation.method(#pause, []),
        returnValue: Future.value(),
        returnValueForMissingStub: Future.value(),
      );

  @override
  Future<void> setReleaseMode(ReleaseMode? releaseMode) => super.noSuchMethod(
        Invocation.method(#setReleaseMode, [releaseMode]),
        returnValue: Future.value(),
        returnValueForMissingStub: Future.value(),
      );

  @override
  Future<void> setPlaybackRate(double? playbackRate) => super.noSuchMethod(
        Invocation.method(#setPlaybackRate, [playbackRate]),
        returnValue: Future.value(),
        returnValueForMissingStub: Future.value(),
      );
      
  @override
  Stream<Duration> get onPositionChanged => super.noSuchMethod(
    Invocation.getter(#onPositionChanged),
    returnValue: const Stream<Duration>.empty(),
    returnValueForMissingStub: const Stream<Duration>.empty(),
  );

  @override
  Stream<PlayerState> get onPlayerStateChanged => super.noSuchMethod(
    Invocation.getter(#onPlayerStateChanged),
    returnValue: const Stream<PlayerState>.empty(),
    returnValueForMissingStub: const Stream<PlayerState>.empty(),
  );
}

void main() {
  late ChapterPlayerController controller;
  late MockAudioPlayer mockAudioPlayer;

  setUp(() {
    controller = ChapterPlayerController();
    mockAudioPlayer = MockAudioPlayer();
  });

  testWidgets('Sleep timer starts and decrement', (WidgetTester tester) async {
    controller.initialize(
      mockAudioPlayer,
      LyricsReaderModel(),
      const Duration(minutes: 5),
    );
    controller.isPlaying.value = true;

    // Start timer for 2 minutes (120 seconds)
    controller.startSleepTimer(2);
    expect(controller.sleepTimerRemaining.value, 120);

    // Advance time by 1 second
    await tester.pump(const Duration(seconds: 1));
    // Timer.periodic might need pump to trigger?
    // In testWidgets context, async timers are controlled by pump.
    expect(controller.sleepTimerRemaining.value, 119);

    // Advance by 60 seconds
    await tester.pump(const Duration(seconds: 60));
    expect(controller.sleepTimerRemaining.value, 59);

    // Verify fade out logic is triggered indirectly?
    // At 59 seconds, fade out should happen.
    verify(mockAudioPlayer.setVolume(any)).called(greaterThan(0));
    
    // Clean up
    controller.cancelSleepTimer();
  });

  testWidgets('Sleep timer stops playback when time is up', (WidgetTester tester) async {
    controller.initialize(
      mockAudioPlayer,
      LyricsReaderModel(),
      const Duration(minutes: 5),
    );
    controller.isPlaying.value = true;
    
    // Start timer for 1 minute
    controller.startSleepTimer(1); // 60 seconds
    
    // Advance 60 seconds
    await tester.pump(const Duration(seconds: 60)); 
    // Wait, initial was 60. 
    // After 1 sec -> 59.
    // After 60 sec -> 0.
    
    // Actually we need to advance 61 times or just pump duration.
    // Pump duration works for Timer.
    await tester.pump(const Duration(seconds: 1)); // 59
    
    // Let's jump to end
    await tester.pump(const Duration(seconds: 60)); // Should be -1 or 0 and stop.

    // Check if stopped
    expect(controller.isPlaying.value, false);
    verify(mockAudioPlayer.pause()).called(1);
    
    // Check if volume reset
    verify(mockAudioPlayer.setVolume(1.0)).called(greaterThanOrEqualTo(1));
  });

  testWidgets('Cancel timer clears state', (WidgetTester tester) async {
    controller.initialize(
      mockAudioPlayer,
      LyricsReaderModel(),
      const Duration(minutes: 5),
    );
    controller.startSleepTimer(10);
    expect(controller.sleepTimerRemaining.value, 600);
    
    controller.cancelSleepTimer();
    expect(controller.sleepTimerRemaining.value, null);
  });
}
