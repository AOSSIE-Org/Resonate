import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/utils/ui_sizes.dart';

import '../../controllers/pair_chat_controller.dart';
import '../../utils/constants.dart';

class PairChatScreen extends StatelessWidget {
  AuthStateController authStateController = Get.find<AuthStateController>();
  PairChatController controller = Get.find<PairChatController>();

  PairChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Brightness currentBrightness = Theme.of(context).brightness;

    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: (UiSizes.size_56),
            automaticallyImplyLeading: false,
            title: Text(
              "Resonate",
              style: TextStyle(
                fontSize: UiSizes.size_26,
              ),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: UiSizes.height_10,
                      horizontal: UiSizes.width_20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Image.asset("assets/images/resonate_logo.png", height: Get.height*0.2,),
                      const Text(
                        "Be polite and respect the other person's opinion. Avoid rude comments.",
                        style: TextStyle(color: Colors.amber),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: UiSizes.height_24_6,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                    controller.isAnonymous.value
                                        ? userProfileImagePlaceholderUrl
                                        : authStateController.profileImageUrl!),
                                radius: UiSizes.width_66,
                              ),
                              SizedBox(
                                height: UiSizes.height_12,
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: UiSizes.width_100,
                                child: Text(
                                  controller.isAnonymous.value
                                      ? "User1"
                                      : authStateController.userName!,
                                  style: TextStyle(fontSize: UiSizes.size_14),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                          Container(
                            width: UiSizes.width_33,
                            height: 2,
                            color: Colors.amber,
                          ),
                          Column(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                    controller.isAnonymous.value
                                        ? userProfileImagePlaceholderUrl
                                        : controller.pairProfileImageUrl!),
                                radius: UiSizes.width_66,
                              ),
                              SizedBox(
                                height: UiSizes.height_12,
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: UiSizes.width_100,
                                child: Text(
                                  controller.isAnonymous.value
                                      ? "User2"
                                      : controller.pairUsername!,
                                  style: TextStyle(fontSize: UiSizes.size_14),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: UiSizes.height_24_6,
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(vertical: UiSizes.height_20),
                color: currentBrightness == Brightness.light
                    ? Colors.amber[100]
                    : Colors.black,
                height: UiSizes.height_131,
                child: Obx(() {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: UiSizes.height_56,
                            width: UiSizes.width_56,
                            child: FloatingActionButton(
                              elevation: 0,
                              heroTag: "mic",
                              onPressed: () {
                                controller.toggleMic();
                              },
                              backgroundColor: controller.isMicOn.value
                                  ? currentBrightness == Brightness.light
                                      ? Colors.white
                                      : Colors.white54
                                  : Colors.amber,
                              child: Icon(
                                Icons.mic_off,
                                size: UiSizes.size_24,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: UiSizes.height_4,
                          ),
                          Text(
                            'Mute',
                            style: TextStyle(fontSize: UiSizes.height_14),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: UiSizes.height_56,
                            width: UiSizes.width_56,
                            child: FloatingActionButton(
                              elevation: 0,
                              heroTag: "speaker",
                              onPressed: () {
                                controller.toggleLoudSpeaker();
                              },
                              backgroundColor: controller.isLoudSpeakerOn.value
                                  ? Colors.amber
                                  : currentBrightness == Brightness.light
                                      ? Colors.white
                                      : Colors.white54,
                              child: Icon(
                                Icons.volume_up,
                                size: UiSizes.size_24,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: UiSizes.height_4,
                          ),
                          Text(
                            'Speaker',
                            style: TextStyle(fontSize: UiSizes.height_14),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: UiSizes.height_56,
                            width: UiSizes.width_56,
                            child: FloatingActionButton(
                              elevation: 0,
                              heroTag: "end-chat",
                              onPressed: () async {
                                await controller.endChat();
                              },
                              backgroundColor: Colors.redAccent,
                              child: Icon(
                                Icons.cancel_outlined,
                                size: UiSizes.size_24,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: UiSizes.height_4,
                          ),
                          Text(
                            "End",
                            style: TextStyle(fontSize: UiSizes.height_14),
                          )
                        ],
                      ),
                    ],
                  );
                }),
              )
            ],
          ),
        ),
        onWillPop: () async => false);
  }
}
