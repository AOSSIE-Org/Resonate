//import required packages
import 'dart:developer';

import 'package:get/get.dart';
import 'package:resonate/views/widgets/no_connection_dialog.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

//is used to manage network connectivity using internet_connection_checker_plus package
class NetworkController extends GetxController {
  final _connectivity = InternetConnectionCheckerPlus(); //create an instance of InternetConnectionCheckerPlus() class from internet_connection_checker_plus package

  @override
  void onInit() {
    super.onInit();

    _connectivity.onStatusChange.listen((status) {  //check the status of network
      if (status == InternetConnectionStatus.disconnected) { //if device is disconnected from network then show a NoConnectionDialog defined in lib/views/widgets/no_connection_dialog.dart
        Get.dialog(const NoConnectionDialog(), barrierDismissible: false);
      } else {
        if (Get.isDialogOpen!) {
          Get.back();
        }
      }
    });
  }
  //tryAgain method asynchronously checks the current connection status. 
  //If the device is connected to the internet, it dismisses any open dialog.
  void tryAgain()async {
    var status = await _connectivity.connectionStatus;
    log(status.toString());
    if (status == InternetConnectionStatus.connected){
      if (Get.isDialogOpen!) {
        Get.back();
      }
    }
  }
}
