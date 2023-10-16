import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/utils/colors.dart';
import 'package:resonate/utils/enums/message_type_enum.dart';

SnackbarController customSnackbar(
    String title, String message, MessageType messageType) {
  Brightness currentBrightness = Theme.of(Get.context!).brightness;

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
    backgroundColor: currentBrightness == Brightness.light
        ? Colors.white
        : AppColor.bgBlackColor,
    colorText:
        currentBrightness == Brightness.light ? Colors.black : Colors.white,
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
