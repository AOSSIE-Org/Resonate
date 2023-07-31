import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/controllers/single_room_controller.dart';
import 'package:resonate/models/appwrite_room.dart';
import '../../utils/colors.dart';
import '../widgets/participant_block.dart';

class RoomScreen extends StatefulWidget {
  final AppwriteRoom room;
  RoomScreen({required this.room});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  @override
  void initState() {
    Get.put(SingleRoomController(appwriteRoom: widget.room));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SingleRoomController controller = Get.find<SingleRoomController>();
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
                  color: Colors.amber.withOpacity(0.5), borderRadius: const BorderRadius.all(Radius.circular(10))),
            ),
          ),
          SizedBox(
            height: Get.height * 0.015,
          ),
          Row(
            children: [
              Text(
                widget.room.name,
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
          Text(getTags(), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w100, color: Colors.white)),
          SizedBox(
            height: Get.height * 0.008,
          ),
          Text(
            widget.room.description,
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
              child: Obx(() {
                return (!controller.isLoading.value)
                    ? GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 20.0,
                          mainAxisSpacing: 5.0,
                          childAspectRatio: 2.5 / 3,
                        ),
                        itemCount: controller.participants.length,
                        itemBuilder: (ctx, index) {
                          return GetBuilder<SingleRoomController>(builder: (controller) => ParticipantBlock(participant: controller.participants[index].value, controller: controller,) );
                        })
                    : Center(
                        child: LoadingAnimationWidget.threeRotatingDots(color: Colors.amber, size: Get.pixelRatio * 20),
                      );
              }),
            ),
          ),
          const Divider(
            thickness: 2,
          ),
          SafeArea(
            child: SizedBox(
              height: Get.height * 0.08,
              child: Column(
                children: [
                  SizedBox(
                    height: Get.height * 0.01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () async {
                          controller.appwriteRoom.isUserAdmin ? await controller.deleteRoom() : await controller.leaveRoom();
                        },
                        child: Container(
                          height: 40,
                          width: 125,
                          decoration: const BoxDecoration(
                              gradient: AppColor.gradientBg, borderRadius: BorderRadius.all(Radius.circular(20))),
                          child: Center(
                              child: Text(
                                (controller.appwriteRoom.isUserAdmin) ? "Delete Room" : "Leave Room",
                            style: const TextStyle(color: Colors.black87),
                          )),
                        ),
                      ),
                      GetBuilder<SingleRoomController>(builder: (controller) {
                        return (controller.me.value.isSpeaker) ? FloatingActionButton(
                          onPressed: () =>
                              (controller.me.value.isMicOn) ? controller.turnOffMic() : controller.turnOnMic(),
                          backgroundColor: (controller.me.value.isMicOn) ? Colors.lightGreen : Colors.redAccent,
                          child: Icon(
                            (controller.me.value.isMicOn) ? Icons.mic : Icons.mic_off,
                            color: Colors.black,
                          ),
                        ) : FloatingActionButton(
                          onPressed: () => (controller.me.value.hasRequestedToBeSpeaker) ? controller.unRaiseHand() : controller.raiseHand(),
                          backgroundColor: (controller.me.value.hasRequestedToBeSpeaker) ? Colors.amber : Colors.black54,
                          child: Icon(
                            (controller.me.value.hasRequestedToBeSpeaker) ? Icons.back_hand : Icons.back_hand_outlined,
                            color: (controller.me.value.hasRequestedToBeSpeaker) ? Colors.black : Colors.amber,
                          ),
                        );
                      }),
                      Container(
                        height: 40,
                        width: 125,
                        decoration: const BoxDecoration(
                            gradient: AppColor.gradientBg, borderRadius: BorderRadius.all(Radius.circular(20))),
                        child: Center(child: Obx(() {
                          return Text(
                            "${controller.participants.length}+ Active",
                            style: TextStyle(color: Colors.black87),
                          );
                        })),
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

  String getTags() {
    if (widget.room.tags.isEmpty) {
      return "";
    }
    String tagString = widget.room.tags[0] ?? "";
    for (var tag in widget.room.tags.sublist(1)) {
      tagString += " · $tag";
    }
    return tagString;
  }
}
