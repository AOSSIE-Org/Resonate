import 'package:flutter/material.dart';
import 'package:resonate/l10n/app_localizations.dart';

Future<bool> confirmSessionExit(BuildContext context, String action) async {
  final l10n = AppLocalizations.of(context)!;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.areYouSure),
      content: Text(l10n.toRoomAction(action)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.confirm),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}
