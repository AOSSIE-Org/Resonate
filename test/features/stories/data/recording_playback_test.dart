import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/stories/data/recording_playback.dart';
import 'package:resonate/features/stories/data/services/recording_audio.dart';
import 'package:resonate/features/stories/model/recorded_chapter.dart';

import '../../../helpers/test_root_container.dart';

RecordedChapter chapterNamed(String id, {int durationMs = 5000}) =>
    RecordedChapter(
      id: id,
      title: 'Recording $id',
      description: '',
      audioFilePath: '/recordings/$id.wav',
      durationMs: durationMs,
      transcript: '',
      recordedAt: DateTime.utc(2026, 1, 1),
    );

void main() {
  late FakeAudioPlayer audio;

  setUp(() => audio = FakeAudioPlayer());

  ProviderContainer install() {
    final container = ProviderContainer(
      overrides: [recordingAudioPlayerProvider.overrideWithValue(audio)],
    );
    addTearDown(container.dispose);
    container.listen(recordingPlaybackProvider, (_, _) {});
    return container;
  }

  // Lets the stream listeners run.
  Future<void> settle() => Future<void>.delayed(Duration.zero);

  test('nothing is loaded to begin with', () {
    final container = install();

    expect(container.read(recordingPlaybackProvider).chapterId, isNull);
    expect(container.read(recordingPlaybackProvider).isPlaying, isFalse);
  });

  test('the first toggle loads the file and plays it', () async {
    final container = install();

    await container
        .read(recordingPlaybackProvider.notifier)
        .toggle(chapterNamed('c1'));

    expect(audio.sourcePath, '/recordings/c1.wav');
    expect(audio.calls, ['load', 'resume']);
    final state = container.read(recordingPlaybackProvider);
    expect(state.chapterId, 'c1');
    expect(state.isPlaying, isTrue);
    // The stored duration carries the scrubber until the player reports one.
    expect(state.duration, const Duration(milliseconds: 5000));
  });

  test('toggling again pauses without reloading', () async {
    final container = install();
    final notifier = container.read(recordingPlaybackProvider.notifier);

    await notifier.toggle(chapterNamed('c1'));
    await notifier.toggle(chapterNamed('c1'));

    expect(audio.calls, ['load', 'resume', 'pause']);
    expect(container.read(recordingPlaybackProvider).isPlaying, isFalse);
  });

  test('a different recording replaces the loaded one', () async {
    final container = install();
    final notifier = container.read(recordingPlaybackProvider.notifier);

    await notifier.toggle(chapterNamed('c1'));
    await notifier.toggle(chapterNamed('c2'));

    expect(audio.sourcePath, '/recordings/c2.wav');
    expect(container.read(recordingPlaybackProvider).chapterId, 'c2');
    expect(container.read(recordingPlaybackProvider).isPlaying, isTrue);
  });

  test('position and duration follow the player', () async {
    final container = install();
    await container
        .read(recordingPlaybackProvider.notifier)
        .toggle(chapterNamed('c1'));

    audio.emitPosition(const Duration(seconds: 2));
    audio.emitDuration(const Duration(seconds: 9));
    await settle();

    final state = container.read(recordingPlaybackProvider);
    expect(state.position, const Duration(seconds: 2));
    expect(state.duration, const Duration(seconds: 9));
  });

  test('reaching the end rewinds and stops playing', () async {
    final container = install();
    await container
        .read(recordingPlaybackProvider.notifier)
        .toggle(chapterNamed('c1'));
    audio.emitPosition(const Duration(seconds: 4));
    await settle();

    audio.complete();
    await settle();

    final state = container.read(recordingPlaybackProvider);
    expect(state.isPlaying, isFalse);
    expect(state.position, Duration.zero);
    // Still loaded, so pressing play starts it again.
    expect(state.chapterId, 'c1');
  });

  test('seek moves the playhead', () async {
    final container = install();
    final notifier = container.read(recordingPlaybackProvider.notifier);
    await notifier.toggle(chapterNamed('c1'));

    await notifier.seek(const Duration(seconds: 3));

    expect(audio.calls.last, 'seek');
    expect(
      container.read(recordingPlaybackProvider).position,
      const Duration(seconds: 3),
    );
  });

  test('seeking with nothing loaded does not reach the player', () async {
    final container = install();

    await container
        .read(recordingPlaybackProvider.notifier)
        .seek(const Duration(seconds: 3));

    expect(audio.calls, isEmpty);
  });

  test('stop releases the recording and stops tracking it', () async {
    final container = install();
    final notifier = container.read(recordingPlaybackProvider.notifier);
    await notifier.toggle(chapterNamed('c1'));

    await notifier.stop();

    expect(audio.calls.last, 'stop');
    expect(container.read(recordingPlaybackProvider).chapterId, isNull);

    // The subscriptions are gone, so a late event cannot revive the state.
    audio.emitPosition(const Duration(seconds: 7));
    await settle();
    expect(container.read(recordingPlaybackProvider).position, Duration.zero);
  });

  test('stopping when nothing is loaded is a no-op', () async {
    final container = install();

    await container.read(recordingPlaybackProvider.notifier).stop();

    expect(audio.calls, isEmpty);
  });
}
