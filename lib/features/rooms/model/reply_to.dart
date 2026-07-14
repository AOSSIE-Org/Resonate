import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/reply_to.freezed.dart';
part 'generated/reply_to.g.dart';

@freezed
abstract class ReplyTo with _$ReplyTo {
  const factory ReplyTo({
    required String messageId,
    required String creatorUsername,
    required String creatorImgUrl,
    required int index,
    required String content,
  }) = _ReplyTo;

  factory ReplyTo.fromJson(Map<String, dynamic> json) => _$ReplyToFromJson(json);
}
