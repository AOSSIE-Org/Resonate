// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserReportModel _$UserReportModelFromJson(Map<String, dynamic> json) =>
    _UserReportModel(
      reporterUid: json['reporterUid'] as String,
      reportedUid: json['reportedUid'] as String,
      reportText: json['reportText'] as String?,
      reportType: $enumDecode(_$ReportTypeEnumEnumMap, json['reportType']),
      reportedUser: json['reportedUser'] as String,
    );

Map<String, dynamic> _$UserReportModelToJson(_UserReportModel instance) =>
    <String, dynamic>{
      'reporterUid': instance.reporterUid,
      'reportedUid': instance.reportedUid,
      'reportText': instance.reportText,
      'reportType': _$ReportTypeEnumEnumMap[instance.reportType]!,
      'reportedUser': instance.reportedUser,
    };

const _$ReportTypeEnumEnumMap = {
  ReportTypeEnum.harassment: 'harassment',
  ReportTypeEnum.abuse: 'abuse',
  ReportTypeEnum.spam: 'spam',
  ReportTypeEnum.impersonation: 'impersonation',
  ReportTypeEnum.illegal: 'illegal',
  ReportTypeEnum.selfharm: 'selfharm',
  ReportTypeEnum.misuse: 'misuse',
};
