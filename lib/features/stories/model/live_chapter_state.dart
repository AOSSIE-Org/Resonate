import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:resonate/features/stories/model/live_chapter_model.dart';

part 'generated/live_chapter_state.freezed.dart';

@freezed
abstract class LiveChapterState with _$LiveChapterState {
  const factory LiveChapterState({
    LiveChapterModel? model,
    @Default(false) bool isMicOn,
    @Default(AsyncValue<String>.data('')) AsyncValue<String> transcript,
  }) = _LiveChapterState;
}
