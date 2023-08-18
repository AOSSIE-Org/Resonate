import 'dart:developer';

import 'package:get/get.dart';
import 'package:resonate/views/widgets/no_connection_dialog.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkController extends GetxController {
  final _connectivity = InternetConnectionCheckerPlus();

  @override
  void onInit() {
    super.onInit();

    _connectivity.onStatusChange.listen((status) {
      if (status == InternetConnectionStatus.disconnected) {
        Get.dialog(const NoConnectionDialog(), barrierDismissible: false);
      } else {
        if (Get.isDialogOpen!) {
          Get.back();
        }
      }
    });
  }

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
