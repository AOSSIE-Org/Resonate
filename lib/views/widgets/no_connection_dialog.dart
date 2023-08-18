import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:resonate/controllers/network_controller.dart';

import '../../utils/colors.dart';

class NoConnectionDialog extends StatelessWidget {
  const NoConnectionDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
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
                  Get.find<NetworkController>().tryAgain();
                },
                child: const Text(
                  "Try Again",
                  style: TextStyle(color: Colors.black),
                ))
          ],
        ),
      ),
    ), onWillPop:() async => false);
  }
}
