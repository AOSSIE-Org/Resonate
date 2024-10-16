import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/utils/enums/log_type.dart';

SnackbarController customSnackbar(
  String title,
  String message,
  LogType messageType,
) {
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

  return Get.snackbar(
    title,
    message,
    backgroundColor: Theme.of(Get.context!).colorScheme.surface,
    titleText: Text(
      title,
      style: TextStyle(
        color: messageTypeColor(),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    borderColor: messageTypeColor(),
    borderWidth: 1,
  );
}
