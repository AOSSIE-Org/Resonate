import 'package:flutter/material.dart';
import 'package:resonate/routes/app_router.dart';
import 'package:resonate/utils/enums/log_type.dart';

void customSnackbar(
  String title,
  String message,
  LogType messageType, {
  int snackbarDuration = 3,
}) {
  Color messageTypeColor() {
    switch (messageType) {
      case LogType.success:
        return Colors.green;
      case LogType.warning:
        return Colors.amber;
      case LogType.error:
        return Colors.red;
      case LogType.info:
        return Colors.blue;
    }
  }

  final ctx = rootNavigatorKey.currentContext;
  if (ctx == null) return;

  final messenger = ScaffoldMessenger.maybeOf(ctx);
  if (messenger == null) return;

  final color = messageTypeColor();
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(ctx).colorScheme.surface,
        duration: Duration(seconds: snackbarDuration),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: color, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(message),
          ],
        ),
      ),
    );
}
