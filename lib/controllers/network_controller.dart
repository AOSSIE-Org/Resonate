import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/views/new_widgets/new_no_connection_dialog.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkController extends GetxController {
  final _connectivity = InternetConnectionCheckerPlus();

  Rx<bool> isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    _connectivity.onStatusChange.listen((status) {
      if (status == InternetConnectionStatus.disconnected) {
        Get.dialog(
          barrierColor: Colors.transparent,
          NewNoConnectionDialog(),
          barrierDismissible: false,
        );
      } else {
        if (Get.isDialogOpen!) {
          Get.back();
        }
      }
    });
  }

  void tryAgain() async {
    isLoading.value = true;

    var status = await _connectivity.connectionStatus;

    log(status.toString());
    if (status == InternetConnectionStatus.connected) {
      if (Get.isDialogOpen!) {
        Get.back();
      }
    }

    isLoading.value = false;
  }
}
