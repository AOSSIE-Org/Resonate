import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

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
          Scaffold(
            body: Container(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
              color: AppColor.bgBlackColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/images/no_connection.svg",
                    height: Get.height * 0.3,
                  ),
                  const Text(
                    "No Connection",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600, color: Colors.amber),
                  ),
                  const Text(
                    "There is a connection error. Please check your internet and try again.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: Get.height * 0.1,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        //This is just use to improve the UI. The dialog will be dismissed as soon as the connection is restored.
                      },
                      child: const Text(
                        "Try Again",
                        style: TextStyle(color: Colors.black),
                      ))
                ],
              ),
            ),
          ),
          barrierDismissible: false);
    } else {
      bool isDeviceConnected = await InternetConnectionChecker().hasConnection;
      if (isDeviceConnected && Get.isDialogOpen!) {
        Get.back();
      }
    }
  }
}
