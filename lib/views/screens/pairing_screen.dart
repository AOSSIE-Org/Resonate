import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/controllers/pair_chat_controller.dart';
import 'package:resonate/utils/colors.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/ui_sizes.dart';

class PairingScreen extends StatelessWidget {
  PairChatController controller = Get.find<PairChatController>();

  PairingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgBlackColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: UiSizes.height_20),
          child: Column(
            children: [
              Text(
                "Finding a Random Partner For You",
                style: TextStyle(
                    color: Colors.amber, fontSize: Get.pixelRatio * 6.5),
              ),
              SizedBox(
                height: UiSizes.height_5,
              ),
              Text(
                "Hang on, Good Things take time  🔍",
                style:
                    TextStyle(fontSize: UiSizes.size_14, color: Colors.white),
              ),
              const Spacer(),
              //Image.asset("assets/images/pairing.gif"),
              Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: UiSizes.width_20,
                        vertical: UiSizes.height_20),
                    child: const LoadingIndicator(
                      indicatorType: Indicator.ballScaleMultiple,
                      colors: [
                        AppColor.yellowColor,
                        Colors.amber,
                        Colors.yellow
                      ],
                      strokeWidth: 2,
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: Get.size.height * 0.05,
                        backgroundImage: NetworkImage((controller
                                .isAnonymous.value)
                            ? userProfileImagePlaceholderUrl
                            : Get.find<AuthStateController>().profileImageUrl!),
                      ),
                    ),
                  )
                ],
              ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: UiSizes.width_20),
                child: Column(
                  children: [
                    Text("Quick fact",
                        style: TextStyle(
                            color: Colors.amber,
                            fontSize: Get.pixelRatio * 6.5)),
                    Text(
                      "Resonate is an open source project maintained by AOSSIE. Checkout our github to contribute.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: UiSizes.size_14, color: Colors.white),
                    ),
                    SizedBox(
                      height: UiSizes.height_15,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await controller.cancelRequest();
                      },
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
