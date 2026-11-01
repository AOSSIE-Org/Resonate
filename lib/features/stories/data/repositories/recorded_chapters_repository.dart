import 'dart:developer';
import 'dart:io';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:resonate/features/stories/data/services/recorded_chapter_store.dart';
import 'package:resonate/features/stories/model/recorded_chapter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/recorded_chapters_repository.g.dart';

@Riverpod(keepAlive: true)
RecordedChaptersRepository recordedChaptersRepository(Ref ref) =>
    RecordedChaptersRepository(store: ref.watch(recordedChapterStoreProvider));

class RecordedChaptersRepository {
  RecordedChaptersRepository({required RecordedChapterStore store})
    : _store = store;

  final RecordedChapterStore _store;

  Future<List<RecordedChapter>> fetchAll() async {
    final stored = await _store.readIndex();
    final present = <RecordedChapter>[];
    var changed = false;
    for (final chapter in stored) {
      final file = await _store.audioFile(chapter.id);
      if (file == null) {
        changed = true;
        continue;
      }
      // Transcription turns the mp4 into a wav after the entry was written.
      if (file.path == chapter.audioFilePath) {
        present.add(chapter);
      } else {
        present.add(chapter.copyWith(audioFilePath: file.path));
        changed = true;
      }
    }
    if (changed) await _store.writeIndex(present);
    present.sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
    return present;
  }

  Future<RecordedChapter?> save({
    required String id,
    required String title,
    required String description,
    required String transcript,
    DateTime? recordedAt,
  }) async {
    final file = await _store.audioFile(id);
    if (file == null) return null;

    final chapter = RecordedChapter(
      id: id,
      title: title,
      description: description,
      audioFilePath: file.path,
      durationMs: _durationOf(file),
      transcript: transcript,
      recordedAt: recordedAt?.toUtc() ?? DateTime.now().toUtc(),
    );
    final stored = await _store.readIndex();
    await _store.writeIndex([
      for (final existing in stored)
        if (existing.id != id) existing,
      chapter,
    ]);
    return chapter;
  }

  Future<void> updateDetails({
    required String id,
    required String title,
    required String description,
    required String transcript,
  }) async {
    final stored = await _store.readIndex();
    final index = stored.indexWhere((chapter) => chapter.id == id);
    if (index == -1) return;
    stored[index] = stored[index].copyWith(
      title: title,
      description: description,
      transcript: transcript,
    );
    await _store.writeIndex(stored);
  }

  Future<void> delete(String id) async {
    await _store.deleteAudioFiles(id);
    final stored = await _store.readIndex();
    await _store.writeIndex([
      for (final chapter in stored)
        if (chapter.id != id) chapter,
    ]);
  }

  int _durationOf(File file) {
    try {
      return readMetadata(file).duration?.inMilliseconds ?? 0;
    } catch (e) {
      log('RecordedChaptersRepository: unreadable audio metadata: $e');
      return 0;
    }
  }
}
