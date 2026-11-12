import 'package:flutter/material.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/ui_sizes.dart';

// Mandatory End User License Agreement dialog shown after login.
class EulaDialog extends StatelessWidget {
  const EulaDialog({super.key});

  static Future<bool> show(BuildContext context) async {
    final agreed = await showAdaptiveDialog<bool>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (_) => const EulaDialog(),
    );
    return agreed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    // Block the system back button so the agreement cannot be bypassed.
    return PopScope(
      canPop: false,
      child: AlertDialog(
        backgroundColor: scheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UiSizes.size_20),
        ),
        title: Text(
          l10n.eulaTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: UiSizes.size_16,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Text(
                l10n.eulaBody,
                style: TextStyle(fontSize: UiSizes.size_12),
              ),
            ),
          ),
        ),
        actionsPadding: EdgeInsets.symmetric(
          horizontal: UiSizes.size_20,
          vertical: UiSizes.size_8,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              l10n.eulaDecline,
              style: TextStyle(
                color: scheme.primary,
                fontSize: UiSizes.size_14,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: scheme.primary,
              foregroundColor: scheme.onPrimary,
              padding: EdgeInsets.symmetric(
                horizontal: UiSizes.width_20,
                vertical: UiSizes.height_10,
              ),
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              l10n.eulaAgree,
              style: TextStyle(fontSize: UiSizes.size_14),
            ),
          ),
        ],
      ),
    );
  }
}
