import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:resonate/utils/colors.dart';
import 'package:resonate/views/widgets/participant_block.dart';

import '../models/participant.dart';

class TabViewController extends GetxController {
  RxInt _selectedIndex = 0.obs;
  getIndex() => _selectedIndex.value;
  setIndex(index) => _selectedIndex.value = index;

  void openRoomSheet() {
    showModalBottomSheet(
        context: Get.context!,
        builder: (ctx) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 15),
                    height: 7,
                    width: 80,
                    decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.5),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.015,
                ),
                Row(
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
                Text("Open Source · Flutter",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w100,
                        color: Colors.white)),
                SizedBox(
                  height: Get.height * 0.008,
                ),
                Text(
                  "This is a simple description of the room. You can feature a participant or talk about an event.",
                  style: TextStyle(color: Colors.white70),
                ),
                SizedBox(
                  height: Get.height * 0.008,
                ),
                Divider(
                  thickness: 2,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
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
                Divider(
                  thickness: 2,
                ),
                SafeArea(
                  child: Container(
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
                              decoration: BoxDecoration(
                                  gradient: AppColor.gradientBg,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Center(
                                  child: Text(
                                "Leave Room",
                                style: TextStyle(color: Colors.black87),
                              )),
                            ),
                            FloatingActionButton(
                              onPressed: () {},
                              backgroundColor: Colors.green,
                              child: Icon(
                                Icons.mic,
                                color: Colors.black54,
                              ),
                            ),
                            Container(
                              height: 40,
                              width: 125,
                              decoration: BoxDecoration(
                                  gradient: AppColor.gradientBg,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                              child: Center(
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
        },
        useSafeArea: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        backgroundColor: AppColor.bgBlackColor,
        isScrollControlled: true,
        enableDrag: true,
        isDismissible: false);
  }
}
