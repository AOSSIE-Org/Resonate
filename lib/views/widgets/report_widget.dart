import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/models/user_report_model.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/utils/enums/report_type_enum.dart';
import 'package:resonate/views/widgets/snackbar.dart';

class ReportWidget extends StatefulWidget {
  const ReportWidget({
    super.key,
    required this.participantName,
    required this.participantId,
  });
  final String participantName;
  final String participantId;

  @override
  State<ReportWidget> createState() => _ReportWidgetState();
}

class _ReportWidgetState extends State<ReportWidget> {
  ReportTypeEnum? _selectedReportType;
  TextEditingController reportTextController = TextEditingController();
  final AuthStateController authStateController =
      Get.find<AuthStateController>();
  Future<void> _handleReportSubmission() async {
    if (_selectedReportType == null) {
      customSnackbar(
        AppLocalizations.of(context)!.error,
        AppLocalizations.of(context)!.selectReportType,
        LogType.error,
      );
      return;
    }

    try {
      final UserReportModel report = UserReportModel(
        reporterUid: authStateController.uid!,
        reportedUid: widget.participantId,
        reportType: _selectedReportType!,
        reportText: reportTextController.text.isEmpty
            ? null
            : reportTextController.text,
        reportedUser: widget.participantId,
      );
      await authStateController.databases.createDocument(
        databaseId: userDatabaseID,
        collectionId: userReportsCollectionID,
        documentId: ID.unique(),
        data: report.toJson(),
      );
      Get.back(result: true);
      await Future.delayed(Duration(milliseconds: 500));
      customSnackbar(
        AppLocalizations.of(context)!.success,
        AppLocalizations.of(context)!.reportSubmitted,
        LogType.success,
      );

      return;
    } catch (e) {
      log(e.toString());
      customSnackbar(
        AppLocalizations.of(context)!.error,
        '${AppLocalizations.of(context)!.reportFailed}: $e',
        LogType.error,
      );

      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  '${AppLocalizations.of(context)!.reportParticipant} ${widget.participantName}',
                ),
                RadioGroup<ReportTypeEnum>(
                  groupValue: _selectedReportType,
                  onChanged: (value) => setState(() {
                    _selectedReportType = value;
                  }),

                  child: ListView.builder(
                    itemCount: ReportTypeEnum.values.length,
                    itemBuilder: (context, index) {
                      return RadioListTile(
                        value: ReportTypeEnum.values.elementAt(index),
                        title: Text(
                          AppLocalizations.of(context)!.reportType(
                            ReportTypeEnum.values.elementAt(index).name,
                          ),
                        ),
                      );
                    },
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                  ),
                ),
                TextField(
                  controller: reportTextController,
                  maxLines: 3,
                  maxLength: 5000,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: AppLocalizations.of(
                      context,
                    )!.additionalDetailsOptional,
                  ),
                ),
                ElevatedButton(
                  onPressed: _handleReportSubmission,
                  child: Text(AppLocalizations.of(context)!.submitReport),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
