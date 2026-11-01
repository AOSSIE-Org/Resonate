import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/stories/data/repositories/recorded_chapters_repository.dart';
import 'package:resonate/features/stories/data/services/recorded_chapter_store.dart';
import 'package:resonate/features/stories/model/recorded_chapter.dart';
import 'package:resonate/features/stories/viewmodel/recorded_chapters_notifier.dart';

RecordedChapter fakeRecordedChapter({
  String id = 'c1',
  String title = 'Recording',
}) => RecordedChapter(
  id: id,
  title: title,
  description: 'desc',
  audioFilePath: '/recordings/$id.wav',
  durationMs: 1000,
  transcript: '',
  recordedAt: DateTime.utc(2026, 1, 1),
);

// Extends the real repository so the fake cannot drift from its signatures.
class _FakeRepository extends RecordedChaptersRepository {
  _FakeRepository({required this.chapters, this.deleteFails = false})
    : super(
        store: RecordedChapterStore(
          directory: () async => Directory.systemTemp,
        ),
      );

  List<RecordedChapter> chapters;
  final bool deleteFails;
  final deleted = <String>[];

  @override
  Future<List<RecordedChapter>> fetchAll() async => chapters;

  @override
  Future<void> delete(String id) async {
    if (deleteFails) throw const FileSystemException('recording is locked');
    deleted.add(id);
    chapters = [
      for (final chapter in chapters)
        if (chapter.id != id) chapter,
    ];
  }
}

void main() {
  ProviderContainer install(_FakeRepository repository) {
    final container = ProviderContainer(
      overrides: [
        recordedChaptersRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    // Without a listener the autoDispose provider is torn down between reads.
    container.listen(recordedChaptersProvider, (_, _) {});
    return container;
  }

  test('build loads the recordings from the repository', () async {
    final container = install(
      _FakeRepository(chapters: [fakeRecordedChapter(title: 'Night Shift')]),
    );

    final chapters = await container.read(recordedChaptersProvider.future);
    expect(chapters.single.title, 'Night Shift');
  });

  test('delete drops the row before the files are gone', () async {
    final repository = _FakeRepository(
      chapters: [
        fakeRecordedChapter(id: 'c1'),
        fakeRecordedChapter(id: 'c2'),
      ],
    );
    final container = install(repository);
    await container.read(recordedChaptersProvider.future);

    final pending = container
        .read(recordedChaptersProvider.notifier)
        .delete('c1');
    expect(container.read(recordedChaptersProvider).value!.map((c) => c.id), [
      'c2',
    ]);

    await pending;
    expect(repository.deleted, ['c1']);
  });

  test('a failed delete puts the row back and rethrows', () async {
    final repository = _FakeRepository(
      chapters: [
        fakeRecordedChapter(id: 'c1'),
        fakeRecordedChapter(id: 'c2'),
      ],
      deleteFails: true,
    );
    final container = install(repository);
    await container.read(recordedChaptersProvider.future);

    await expectLater(
      container.read(recordedChaptersProvider.notifier).delete('c1'),
      throwsA(isA<FileSystemException>()),
    );
    expect(container.read(recordedChaptersProvider).value!.map((c) => c.id), [
      'c1',
      'c2',
    ]);
  });

  test('refresh picks up recordings added since the last load', () async {
    final repository = _FakeRepository(
      chapters: [fakeRecordedChapter(id: 'c1')],
    );
    final container = install(repository);
    await container.read(recordedChaptersProvider.future);

    repository.chapters = [
      fakeRecordedChapter(id: 'c1'),
      fakeRecordedChapter(id: 'c2'),
    ];
    await container.read(recordedChaptersProvider.notifier).refresh();

    expect(container.read(recordedChaptersProvider).value!.map((c) => c.id), [
      'c1',
      'c2',
    ]);
  });

  test(
    'refresh keeps the current list visible instead of blanking it',
    () async {
      final repository = _FakeRepository(
        chapters: [fakeRecordedChapter(id: 'c1')],
      );
      final container = install(repository);
      await container.read(recordedChaptersProvider.future);

      final pending = container
          .read(recordedChaptersProvider.notifier)
          .refresh();
      expect(container.read(recordedChaptersProvider).isLoading, isFalse);

      await pending;
    },
  );
}
