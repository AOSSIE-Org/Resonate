import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:language_picker/languages.dart';

import '../../controllers/pair_chat_controller.dart';
import '../../routes/app_routes.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';

class PairChatScreen extends StatelessWidget {
  PairChatController controller = Get.find<PairChatController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
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
                  SizedBox(height: Get.height*0.03,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(userProfileImagePlaceholderUrl),
                            radius: Get.width * 0.16,
                          ),
                          SizedBox(height: Get.height*0.015,),
                          FittedBox(child: Text("Chandan",), fit: BoxFit.fitWidth,)
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
                          SizedBox(height: Get.height*0.015,),
                          FittedBox(child: Text("Darshan",), fit: BoxFit.fitWidth,)
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: Get.height*0.03,),

                ],
              ),
            ),
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            color: Colors.black,
            height: Get.height * 0.16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    FloatingActionButton(
                      onPressed: () {},
                      child: Icon(Icons.mic, color: Colors.white),
                      backgroundColor: Colors.white24,
                    ),
                    SizedBox(
                      height: Get.height * 0.005,
                    ),
                    Text("Mute")
                  ],
                ),
                Column(
                  children: [
                    FloatingActionButton(
                      onPressed: () {},
                      child: Icon(Icons.volume_up),
                    ),
                    SizedBox(
                      height: Get.height * 0.005,
                    ),
                    Text("Speaker")
                  ],
                ),
                Column(
                  children: [
                    FloatingActionButton(
                      onPressed: () {},
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
            ),
          )
        ],
      ),
    );
  }
}
