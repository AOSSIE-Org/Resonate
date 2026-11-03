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
    this.maxLength = 5000,
  });
  final String participantName;
  final String participantId;

  final int maxLength;

  @override
  ConsumerState<ReportWidget> createState() => _ReportWidgetState();
}

class _ReportWidgetState extends ConsumerState<ReportWidget> {
  ReportTypeEnum? _selectedReportType;
  final TextEditingController reportTextController = TextEditingController();

  @override
  void dispose() {
    reportTextController.dispose();
    super.dispose();
  }

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
      details: reportTextController.text.trim().isEmpty
          ? null
          : reportTextController.text.trim(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: UiSizes.width_20,
        vertical: UiSizes.height_24_6,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UiSizes.size_20),
      ),
      backgroundColor: scheme.surface,
      child: ConstrainedBox(
        // Cap the height so long reason lists scroll internally while the
        // header and the submit/cancel footer stay pinned and tappable.
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            UiSizes.width_20,
            UiSizes.height_20,
            UiSizes.width_20,
            UiSizes.height_15,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Header: flag icon + "Report Participant <name>" + subtitle.
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(UiSizes.width_8),
                    decoration: BoxDecoration(
                      color: scheme.errorContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.flag_rounded,
                      color: scheme.onErrorContainer,
                      size: UiSizes.size_20,
                    ),
                  ),
                  SizedBox(width: UiSizes.width_10),
                  Expanded(
                    child: Text(
                      '${l10n.reportParticipant} ${widget.participantName}',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: scheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: UiSizes.height_5),
              Text(
                l10n.selectReportType,
                style: textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: UiSizes.height_15),

              // Reasons + optional details scroll together between the pinned
              // header and footer.
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RadioGroup<ReportTypeEnum>(
                        groupValue: _selectedReportType,
                        onChanged: (value) =>
                            setState(() => _selectedReportType = value),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (final type in ReportTypeEnum.values)
                              _ReasonTile(
                                type: type,
                                selected: _selectedReportType == type,
                                label: l10n.reportType(type.name),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: UiSizes.height_15),
                      TextField(
                        controller: reportTextController,
                        maxLines: 3,
                        maxLength: widget.maxLength,
                        textInputAction: TextInputAction.newline,
                        style: textTheme.bodyMedium,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: scheme.surfaceContainerHighest.withValues(
                            alpha: 0.4,
                          ),
                          hintText: l10n.additionalDetailsOptional,
                          hintStyle: TextStyle(color: scheme.onSurfaceVariant),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: UiSizes.width_16,
                            vertical: UiSizes.height_10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              UiSizes.size_12,
                            ),
                            borderSide: BorderSide(
                              color: scheme.outlineVariant,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              UiSizes.size_12,
                            ),
                            borderSide: BorderSide(
                              color: scheme.outlineVariant,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              UiSizes.size_12,
                            ),
                            borderSide: BorderSide(color: scheme.primary),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: UiSizes.height_10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleReportSubmission,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: scheme.error,
                    foregroundColor: scheme.onError,
                    padding: EdgeInsets.symmetric(vertical: UiSizes.height_12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(UiSizes.size_12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.flag_rounded, size: UiSizes.size_16),
                      SizedBox(width: UiSizes.width_8),
                      Text(l10n.submitReport),
                    ],
                  ),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    l10n.cancel,
                    style: TextStyle(color: scheme.onSurfaceVariant),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReasonTile extends StatelessWidget {
  const _ReasonTile({
    required this.type,
    required this.selected,
    required this.label,
  });

  final ReportTypeEnum type;
  final bool selected;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: EdgeInsets.only(bottom: UiSizes.height_5),
      decoration: BoxDecoration(
        color: selected
            ? scheme.primary.withValues(alpha: 0.08)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(UiSizes.size_12),
        border: Border.all(
          color: selected ? scheme.primary : scheme.outlineVariant,
        ),
      ),
      child: RadioListTile<ReportTypeEnum>(
        value: type,
        dense: true,
        visualDensity: VisualDensity.compact,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UiSizes.size_12),
        ),
        title: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: scheme.onSurface,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
