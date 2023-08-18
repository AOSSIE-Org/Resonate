import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:resonate/routes/app_routes.dart';

import '../../controllers/pair_chat_controller.dart';
import '../../utils/constants.dart';

class PairChatScreen extends StatelessWidget {
  PairChatController controller = Get.find<PairChatController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: (0.068 * Get.width + 0.034 * Get.height),
            automaticallyImplyLeading: false,
            title: Text(
              "Resonate",
              style: TextStyle(color: Colors.amber, fontSize: 0.0315 * Get.width + 0.01582 * Get.height),
            ),
            centerTitle: true,
            elevation: 10,
            backgroundColor: const Color.fromRGBO(17, 17, 20, 1),
          ),
          body: Column(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Image.asset("assets/images/resonate_logo.png", height: Get.height*0.2,),
                      Text(
                        "Be polite and respect the other person's opinion. Avoid rude comments.",
                        style: TextStyle(color: Colors.amber),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: Get.height * 0.03,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(userProfileImagePlaceholderUrl),
                                radius: Get.width * 0.16,
                              ),
                              SizedBox(
                                height: Get.height * 0.015,
                              ),
                              FittedBox(
                                child: Text(
                                  "User 1",
                                ),
                                fit: BoxFit.fitWidth,
                              )
                            ],
                          ),
                          Container(
                            width: Get.width * 0.08,
                            height: 2,
                            color: Colors.amber,
                          ),
                          Column(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(userProfileImagePlaceholderUrl),
                                radius: Get.width * 0.16,
                              ),
                              SizedBox(
                                height: Get.height * 0.015,
                              ),
                              FittedBox(
                                child: Text(
                                  "User 2",
                                ),
                                fit: BoxFit.fitWidth,
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Get.height * 0.03,
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                color: Colors.black,
                height: Get.height * 0.16,
                child: Obx(() {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            FloatingActionButton(
                              heroTag: "mic",
                              onPressed: () {
                                controller.toggleMic();
                              },
                              backgroundColor: controller.isMicOn.value ? Colors.amber : Colors.white24,
                              child: controller.isMicOn.value ? Icon(Icons.mic, color: Colors.black,) : Icon(Icons.mic_off, color: Colors.white),
                            ),
                            SizedBox(
                              height: Get.height * 0.005,
                            ),
                            Text(controller.isMicOn.value ? "Mute" : "Unmute")
                          ],
                        ),
                        Column(
                          children: [
                            FloatingActionButton(
                              heroTag: "speaker",
                              onPressed: () {
                                controller.toggleLoudSpeaker();
                              },
                              backgroundColor: controller.isLoudSpeakerOn.value ? Colors.white : Colors.white24,
                              child: controller.isLoudSpeakerOn.value ? Icon(Icons.surround_sound_outlined, color: Colors.black,) : Icon(Icons.volume_up, color: Colors.white),
                            ),
                            SizedBox(
                              height: Get.height * 0.005,
                            ),
                            Text(controller.isLoudSpeakerOn.value ? "Ear" : "Speaker")
                          ],
                        ),
                        Column(
                          children: [
                            FloatingActionButton(
                              heroTag: "end-chat",
                              onPressed: () async {
                                await controller.endChat();
                              },
                              child: Icon(Icons.cancel_outlined),
                              backgroundColor: Colors.redAccent,
                            ),
                            SizedBox(
                              height: Get.height * 0.005,
                            ),
                            Text("End")
                          ],
                        ),
                      ],
                    );
                  }
                ),
              )
            ],
          ),
        ),
        onWillPop: () async => false);
  }
}
