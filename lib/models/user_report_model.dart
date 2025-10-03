import 'package:appwrite/models.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:resonate/utils/enums/report_type_enum.dart';

part 'user_report_model.freezed.dart';
part 'user_report_model.g.dart';

//This model is only supposed to be used when sending reports to the database, to use while recieving modify the fromJson method for reportedUser (Relationship attribute)

@freezed
abstract class UserReportModel with _$UserReportModel {
  factory UserReportModel({
    required final String reporterUid,
    required final String reportedUid,
    final String? reportText,
    required final ReportTypeEnum reportType,
    required final String reportedUser,
  }) = _UserReportModel;

  factory UserReportModel.fromJson(Map<String, dynamic> json) =>
      _$UserReportModelFromJson(json);
}
