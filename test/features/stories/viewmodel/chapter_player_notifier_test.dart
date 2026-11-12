import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/stories/data/services/chapter_audio.dart';
import 'package:resonate/features/stories/viewmodel/chapter_player_notifier.dart';

// Stands in for the audio SDK so playback can be driven without a platform
// channel. Before `ChapterAudio` existed the notifier built its own
// AudioPlayer, which left everything below untestable.
class _FakeChapterAudio implements ChapterAudio {
  final _position = StreamController<Duration>.broadcast();
  final _playing = StreamController<bool>.broadcast();

  String? loadedUrl;
  int playCount = 0;
  int pauseCount = 0;
  int releaseCount = 0;
  final seeks = <Duration>[];

  @override
  Stream<Duration> get positionChanges => _position.stream;

  @override
  Stream<bool> get playingChanges => _playing.stream;

  @override
  Future<void> load(String url) async => loadedUrl = url;

  @override
  Future<void> play() async => playCount++;

  @override
  Future<void> pause() async => pauseCount++;

  @override
  Future<void> seek(Duration position) async => seeks.add(position);

  @override
  Future<void> release() async => releaseCount++;

  void emitPosition(Duration position) => _position.add(position);

  void emitPlaying(bool playing) => _playing.add(playing);

  void dispose() {
    _position.close();
    _playing.close();
  }
}

void main() {
  setUp(TestWidgetsFlutterBinding.ensureInitialized);

  late _FakeChapterAudio audio;

  setUp(() {
    audio = _FakeChapterAudio();
    addTearDown(audio.dispose);
  });

  ProviderContainer makeContainer() {
    final container = ProviderContainer(
      overrides: [chapterAudioFactoryProvider.overrideWithValue(() => audio)],
    );
    addTearDown(container.dispose);
    return container;
  }

  ChapterPlayer started(ProviderContainer container) {
    final key = chapterPlayerProvider('c1');
    container.listen(key, (_, _) {});
    final notifier = container.read(key.notifier);
    notifier.initialize(
      audioUrl: 'http://audio/c1.mp3',
      lyrics: '',
      duration: const Duration(seconds: 30),
    );
    return notifier;
  }

  test('build returns the default player state', () {
    final container = makeContainer();
    final key = chapterPlayerProvider('c1');
    container.listen(key, (_, _) {});

    final state = container.read(key);

    expect(state.sliderProgress, 0.0);
    expect(state.isPlaying, isFalse);
  });

  test('onSliderChanged updates the slider progress', () {
    final container = makeContainer();
    final key = chapterPlayerProvider('c1');
    container.listen(key, (_, _) {});

    container.read(key.notifier).onSliderChanged(42.0);

    expect(container.read(key).sliderProgress, 42.0);
  });

  test('initialize loads the audio source and keeps the duration', () {
    final container = makeContainer();

    final notifier = started(container);

    expect(audio.loadedUrl, 'http://audio/c1.mp3');
    expect(notifier.chapterDuration, const Duration(seconds: 30));
  });

  test('a position event drives the slider progress', () async {
    final container = makeContainer();
    started(container);

    audio.emitPosition(const Duration(milliseconds: 1500));
    await Future<void>.delayed(Duration.zero);

    expect(container.read(chapterPlayerProvider('c1')).sliderProgress, 1500.0);
  });

  test('a playing event drives isPlaying', () async {
    final container = makeContainer();
    started(container);

    audio.emitPlaying(true);
    await Future<void>.delayed(Duration.zero);

    expect(container.read(chapterPlayerProvider('c1')).isPlaying, isTrue);
  });

  test('togglePlayPause plays when paused and pauses when playing', () async {
    final container = makeContainer();
    final notifier = started(container);

    notifier.togglePlayPause();
    expect(audio.playCount, 1);

    audio.emitPlaying(true);
    await Future<void>.delayed(Duration.zero);
    notifier.togglePlayPause();

    expect(audio.pauseCount, 1);
  });

  test('onSliderChangeEnd seeks to the dragged position', () {
    final container = makeContainer();
    final notifier = started(container);

    notifier.onSliderChangeEnd(2000);

    expect(audio.seeks, [const Duration(milliseconds: 2000)]);
  });

  test('seek passes the position straight through', () {
    final container = makeContainer();
    final notifier = started(container);

    notifier.seek(const Duration(seconds: 5));

    expect(audio.seeks, [const Duration(seconds: 5)]);
  });

  test('disposing the container releases the audio player', () {
    final container = ProviderContainer(
      overrides: [chapterAudioFactoryProvider.overrideWithValue(() => audio)],
    );
    started(container);

    container.dispose();

    expect(audio.releaseCount, 1);
  });
}
