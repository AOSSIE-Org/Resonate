import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/network_controller.dart';
import 'package:resonate/utils/app_images.dart';
import 'package:resonate/utils/ui_sizes.dart';

class NoConnectionDialog extends StatelessWidget {
  const NoConnectionDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          body: Container(
            padding: EdgeInsets.symmetric(
                vertical: UiSizes.height_24_6, horizontal: UiSizes.width_25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AppImages.noConnectionImage,
                  height: UiSizes.height_246,
                ),
                Text(
                  "No Connection",
                  style: TextStyle(
                      fontSize: UiSizes.size_40,
                      fontWeight: FontWeight.w600,
                      color: Colors.amber),
                ),
                Text(
                  "There is a connection error. Please check your internet and try again.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: UiSizes.size_16),
                ),
                SizedBox(
                  height: UiSizes.height_82,
                ),
                ElevatedButton(
                    onPressed: () {
                      Get.find<NetworkController>().tryAgain();
                    },
                    child: Text(
                      "Try Again",
                      style: TextStyle(
                          color: Colors.black, fontSize: UiSizes.size_14),
                    ))
              ],
            ),
          ),
        ),
        onWillPop: () async => false);
  }
}
