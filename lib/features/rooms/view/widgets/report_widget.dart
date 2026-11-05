import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/shared/widgets/snackbar.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/utils/enums/report_type_enum.dart';
import 'package:resonate/utils/ui_sizes.dart';

class ReportWidget extends ConsumerStatefulWidget {
  const ReportWidget({
    super.key,
    required this.participantName,
    required this.participantId,
  });
  final String participantName;
  final String participantId;

  @override
  ConsumerState<ReportWidget> createState() => _ReportWidgetState();
}

class _ReportWidgetState extends ConsumerState<ReportWidget> {
  ReportTypeEnum? _selectedReportType;
  TextEditingController reportTextController = TextEditingController();
  Future<void> _handleReportSubmission() async {
    if (_selectedReportType == null) {
      customSnackbar(
        AppLocalizations.of(context)!.error,
        AppLocalizations.of(context)!.selectReportType,
        LogType.error,
      );
      return;
    }

    Navigator.of(context).pop((
      type: _selectedReportType!,
      details: reportTextController.text.isEmpty
          ? null
          : reportTextController.text,
    ));
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
            padding: EdgeInsets.all(UiSizes.width_8),
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
