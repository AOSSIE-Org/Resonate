import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/utils/enums/message_type_enum.dart';

SnackbarController customSnackbar(
  String title,
  String message,
  MessageType messageType,
) {
  Color messageTypeColor() {
    switch (messageType) {
      case MessageType.success:
        return Colors.green;
      case MessageType.warning:
        return Colors.amber;
      case MessageType.error:
        return Colors.red;
      case MessageType.info:
        return Colors.blue;
    }
  }

  return Get.snackbar(
    title,
    message,
    backgroundColor: Theme.of(Get.context!).colorScheme.background,
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
