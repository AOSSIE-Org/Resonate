import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/stories_failure.freezed.dart';

@freezed
sealed class StoriesFailure with _$StoriesFailure {
  const factory StoriesFailure.upload(String what) = StoriesFailureUpload;
  const factory StoriesFailure.unknown(String message) = StoriesFailureUnknown;
}
