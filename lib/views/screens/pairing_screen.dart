import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/utils/colors.dart';

class PairingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgBlackColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Text(
                "Finding a Random Partner For You",
                style: TextStyle(color: Colors.amber, fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Text("Hang on, Good Things take time  🔍"),
              Spacer(),
              //Image.asset("assets/images/pairing.gif"),
               Stack(
                children: [
                  LoadingIndicator(
                    indicatorType: Indicator.ballScaleMultiple,
                    colors: [AppColor.yellowColor, Colors.amber, Colors.yellow],
                    strokeWidth: 25,
                  ),
                ],
              ),

              Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Text("Quick fact", style: TextStyle(color: Colors.amber, fontSize: 20)),
                    Text(
                      "Resonate is an open source project maintained by AOSSIE. You can add your own features.",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: Get.height * 0.08,
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.yellowColor,
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: Get.pixelRatio * 8,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
