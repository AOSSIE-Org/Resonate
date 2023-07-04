import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/single_room_controller.dart';

import '../../models/participant.dart';
import '../../utils/colors.dart';
import '../widgets/participant_block.dart';

class RoomScreen extends StatelessWidget {

  SingleRoomController s = Get.put(SingleRoomController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              height: 7,
              width: 80,
              decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.5),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
            ),
          ),
          SizedBox(
            height: Get.height * 0.015,
          ),
          const Row(
            children: [
              Text(
                "For the love of open source ♥",
                style: TextStyle(fontSize: 20, color: Colors.amber),
              ),
              Spacer(),
              FaIcon(
                FontAwesomeIcons.ellipsis,
                color: Colors.amber,
              ),
            ],
          ),
          SizedBox(
            height: Get.height * 0.001,
          ),
          const Text("Open Source · Flutter",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w100,
                  color: Colors.white)),
          SizedBox(
            height: Get.height * 0.008,
          ),
          const Text(
            "This is a simple description of the room. You can feature a participant or talk about an event.",
            style: TextStyle(color: Colors.white70),
          ),
          SizedBox(
            height: Get.height * 0.008,
          ),
          const Divider(
            thickness: 2,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: GridView.builder(
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 20.0,
                    mainAxisSpacing: 5.0,
                    childAspectRatio: 2.5 / 3,
                  ),
                  itemCount: 15,
                  itemBuilder: (ctx, index) {
                    // TODO: Sample Participant - replace it
                    Participant participantObj = Participant(
                        email: "c@c.com",
                        name: "Chandan",
                        dpUrl:
                        "https://avatars.githubusercontent.com/u/41890434?v=4",
                        isAdmin: index==0,
                        isMicOn: index%2==0,
                        isModerator: false,
                        isSpeaker: index<6,
                        isSpeaking: false);
                    return ParticipantBlock(participant: participantObj);
                  }),
            ),
          ),
          const Divider(
            thickness: 2,
          ),
          SafeArea(
            child: SizedBox(
              height: Get.height * 0.075,
              child: Column(
                children: [
                  SizedBox(height: Get.height*0.01,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 40,
                        width: 125,
                        decoration: const BoxDecoration(
                            gradient: AppColor.gradientBg,
                            borderRadius:
                            BorderRadius.all(Radius.circular(20))),
                        child: const Center(
                            child: Text(
                              "Leave Room",
                              style: TextStyle(color: Colors.black87),
                            )),
                      ),
                      FloatingActionButton(
                        onPressed: () {},
                        backgroundColor: Colors.lightGreen,
                        child: const Icon(
                          Icons.mic,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 125,
                        decoration: const BoxDecoration(
                            gradient: AppColor.gradientBg,
                            borderRadius:
                            BorderRadius.all(Radius.circular(20))),
                        child: const Center(
                            child: Text(
                              "26+ Active",
                              style: TextStyle(color: Colors.black87),
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}