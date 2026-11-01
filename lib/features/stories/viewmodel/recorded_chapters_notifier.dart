import 'package:resonate/features/stories/data/repositories/recorded_chapters_repository.dart';
import 'package:resonate/features/stories/model/recorded_chapter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/recorded_chapters_notifier.g.dart';

// Screen state for the recorded chapters list and its detail view
@riverpod
class RecordedChapters extends _$RecordedChapters {
  @override
  Future<List<RecordedChapter>> build() =>
      ref.watch(recordedChaptersRepositoryProvider).fetchAll();

  Future<void> refresh() async {
    final repository = ref.read(recordedChaptersRepositoryProvider);
    final chapters = await AsyncValue.guard(repository.fetchAll);
    if (ref.mounted) state = chapters;
  }

  Future<void> delete(String id) async {
    final previous = state.value ?? const <RecordedChapter>[];
    final repository = ref.read(recordedChaptersRepositoryProvider);
    state = AsyncData([
      for (final chapter in previous)
        if (chapter.id != id) chapter,
    ]);
    try {
      await repository.delete(id);
    } catch (_) {
      if (ref.mounted) state = AsyncData(previous);
      rethrow;
    }
  }
}
