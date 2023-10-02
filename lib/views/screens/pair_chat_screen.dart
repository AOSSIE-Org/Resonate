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
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: (UiSizes.size_56),
            automaticallyImplyLeading: false,
            title: Text(
              "Resonate",
              style: TextStyle(color: Colors.amber, fontSize: UiSizes.size_26),
            ),
            centerTitle: true,
            elevation: 10,
            backgroundColor: const Color.fromRGBO(17, 17, 20, 1),
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
                              FittedBox(
                                child: Text(
                                    controller.isAnonymous.value
                                        ? "User1"
                                        : authStateController.userName!,
                                    style:
                                        TextStyle(fontSize: UiSizes.size_14)),
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
                              FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  controller.isAnonymous.value
                                      ? "User2"
                                      : controller.pairUsername!,
                                  style: TextStyle(fontSize: UiSizes.size_14),
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
                color: Colors.black,
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
                              heroTag: "mic",
                              onPressed: () {
                                controller.toggleMic();
                              },
                              backgroundColor: controller.isMicOn.value
                                  ? Colors.amber
                                  : Colors.white24,
                              child: controller.isMicOn.value
                                  ? Icon(
                                      Icons.mic,
                                      color: Colors.black,
                                      size: UiSizes.size_24,
                                    )
                                  : Icon(Icons.mic_off,
                                      color: Colors.white,
                                      size: UiSizes.size_24),
                            ),
                          ),
                          SizedBox(
                            height: UiSizes.height_4,
                          ),
                          Text(
                            controller.isMicOn.value ? "Mute" : "Unmute",
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
                              heroTag: "speaker",
                              onPressed: () {
                                controller.toggleLoudSpeaker();
                              },
                              backgroundColor: controller.isLoudSpeakerOn.value
                                  ? Colors.white
                                  : Colors.white24,
                              child: controller.isLoudSpeakerOn.value
                                  ? Icon(
                                      Icons.surround_sound_outlined,
                                      color: Colors.black,
                                      size: UiSizes.size_24,
                                    )
                                  : Icon(
                                      Icons.volume_up,
                                      color: Colors.white,
                                      size: UiSizes.size_24,
                                    ),
                            ),
                          ),
                          SizedBox(
                            height: UiSizes.height_4,
                          ),
                          Text(
                            controller.isLoudSpeakerOn.value
                                ? "Ear"
                                : "Speaker",
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
