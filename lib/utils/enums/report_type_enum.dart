import 'package:freezed_annotation/freezed_annotation.dart';

enum ReportTypeEnum {
  @JsonValue('harassment')
  harassment,
  @JsonValue('abuse')
  abuse,
  @JsonValue('spam')
  spam,
  @JsonValue('illegal')
  illegal,
  @JsonValue('selfharm')
  selfharm,
  @JsonValue('misuse')
  misuse,
}
