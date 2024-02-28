//import required packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/utils/colors.dart';
import 'package:resonate/utils/enums/message_type_enum.dart';

//SnackbarController is provided by get state management
//customSnackbar function displays a snackbar by returning Get.snackbar().
SnackbarController customSnackbar(
  String title, //title of the snackbar
  String message, //message that the snackbar displays
  MessageType
      messageType, //messageType is an enum defined in lib\utils\enums\message_type_enum.dart
) {
  //get the currentBrightness of device (light or dark)
  Brightness currentBrightness = Theme.of(Get.context!).brightness;
  //messageTypeColor will display a different color for each messageType
  Color messageTypeColor() {
    switch (messageType) {
      case MessageType.success:
        return Colors.green; //green is displayed if messageType is success.
      case MessageType.warning:
        return Colors.amber; //amber is displayed if messageType is warning.
      case MessageType.error:
        return Colors.red; //red is displayed if messageType is error.
      case MessageType.info:
        return Colors.blue; //blue is displayed if messageType is info.
    }
  }

  return Get.snackbar(
    title, //use title specified when widget is called
    message, //use message specified when widget is called
    //change the background color of snackbar based on currentBrightness
    //if currentBrightness is light then white color is used
    //else bgBlackColor from AppColor is used.
    backgroundColor: currentBrightness == Brightness.light
        ? Colors.white
        : AppColor.bgBlackColor,
    //same as above, color of text is changed based on the currentBrightness value.
    colorText:
        currentBrightness == Brightness.light ? Colors.black : Colors.white,
    //title of the snackbar
    titleText: Text(
      title, //get title from parameters
      style: TextStyle(
        //change color based on messageType value
        color: messageTypeColor(),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    //change borderColor based on messageType value
    borderColor: messageTypeColor(),
    borderWidth: 1,
  );
}
