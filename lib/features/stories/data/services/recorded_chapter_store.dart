import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:resonate/features/stories/model/recorded_chapter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/recorded_chapter_store.g.dart';

typedef RecordingsDirectory = Future<Directory> Function();

@Riverpod(keepAlive: true)
RecordedChapterStore recordedChapterStore(Ref ref) => RecordedChapterStore();

class RecordedChapterStore {
  RecordedChapterStore({RecordingsDirectory? directory})
    : _directory = directory ?? _appRecordingsDirectory;

  static const indexFileName = 'recorded_chapters.json';

  // LiveKit records <id>.mp4; transcription converts it to <id>.wav.
  static const _audioExtensions = ['.wav', '.mp4'];

  final RecordingsDirectory _directory;

  static Future<Directory> _appRecordingsDirectory() async {
    final documents = await getApplicationDocumentsDirectory();
    return Directory('${documents.path}/recordings');
  }

  Future<List<RecordedChapter>> readIndex() async {
    final file = File('${(await _directory()).path}/$indexFileName');
    if (!file.existsSync()) return const [];
    try {
      final decoded = jsonDecode(await file.readAsString());
      if (decoded is! List) return const [];
      return [
        for (final entry in decoded)
          if (entry is Map<String, dynamic>) RecordedChapter.fromJson(entry),
      ];
    } catch (e) {
      log('RecordedChapterStore: unreadable index: $e');
      return const [];
    }
  }

  Future<void> writeIndex(List<RecordedChapter> chapters) async {
    final directory = await _directory();
    if (!directory.existsSync()) await directory.create(recursive: true);
    await File(
      '${directory.path}/$indexFileName',
    ).writeAsString(jsonEncode([for (final c in chapters) c.toJson()]));
  }

  // The recording as it exists now, or null once both files are gone.
  Future<File?> audioFile(String chapterId) async {
    final directory = await _directory();
    for (final extension in _audioExtensions) {
      final file = File('${directory.path}/$chapterId$extension');
      if (file.existsSync()) return file;
    }
    return null;
  }

  Future<void> deleteAudioFiles(String chapterId) async {
    final directory = await _directory();
    for (final extension in _audioExtensions) {
      final file = File('${directory.path}/$chapterId$extension');
      if (file.existsSync()) await file.delete();
    }
  }
}
