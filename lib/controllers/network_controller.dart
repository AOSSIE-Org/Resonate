import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:resonate/views/widgets/no_connection_dialog.dart';

import '../utils/colors.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) async {
    if (connectivityResult == ConnectivityResult.none) {
      Get.dialog(
        const NoConnectionDialog(),
          barrierDismissible: false);
    } else {
      bool isDeviceConnected = await InternetConnectionChecker().hasConnection;
      if (isDeviceConnected && Get.isDialogOpen!) {
        Get.back();
      }
    }
  }
}
