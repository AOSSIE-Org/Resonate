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
  const RoomScreen({super.key, required this.room});

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
      padding: EdgeInsets.symmetric(horizontal: 0.0365*Get.width),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin:  EdgeInsets.symmetric(vertical: 0.01825),
              height: 0.0085*Get.height,
              width: 0.1944*Get.width,
              decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.5),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
            ),
          ),
          SizedBox(
            height: Get.height * 0.015,
          ),
          Row(
            children: [
              Text(
                widget.room.name,
                style: TextStyle(fontSize: 0.012*Get.height+0.0243*Get.width, color: Colors.amber),
              ),
              const Spacer(),
              const FaIcon(
                FontAwesomeIcons.ellipsis,
                color: Colors.amber,
                size: 0.0146*Get.height+0.029*Get.width,
              ),
            ],
          ),
          SizedBox(
            height: Get.height * 0.001,
          ),
          Text(getTags(), style: TextStyle(fontSize: 0.009127*Get.height+0.01823*Get.width, fontWeight: FontWeight.w100, color: Colors.white)),
          SizedBox(
            height: Get.height * 0.008,
          ),
          Text(
            widget.room.description,
            style: TextStyle(color: Colors.white70, fontSize: 0.0085 * Get.height + 0.017 * Get.width),
          ),
          SizedBox(
            height: Get.height * 0.008,
          ),
          Divider(
            thickness: 0.0024*Get.height,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 0.006*Get.height),
              child: Obx(() {
                return (!controller.isLoading.value)
                    ? GridView.builder(
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 0.0486*Get.width,
                          mainAxisSpacing: 0.006*Get.height,
                          childAspectRatio: 2.5 / 3,
                        ),
                        itemCount: controller.participants.length,
                        itemBuilder: (ctx, index) {
                          return GetBuilder<SingleRoomController>(
                              builder: (controller) => ParticipantBlock(
                                    participant:
                                        controller.participants[index].value,
                                    controller: controller,
                                  ));
                        })
                    : Center(
                        child: LoadingAnimationWidget.threeRotatingDots(
                            color: Colors.amber, size: Get.pixelRatio * 20),
                      );
              }),
            ),
          ),
          Divider(
            thickness: 0.0024*Get.height,
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
                          controller.appwriteRoom.isUserAdmin
                              ? await controller.deleteRoom()
                              : await controller.leaveRoom();
                        },
                        child: Container(
                          height: 0.0486*Get.height,
                          width: 0.3*Get.width,
                          decoration: const BoxDecoration(
                              gradient: AppColor.gradientBg,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Center(
                              child: Text(
<<<<<<< HEAD
                                (controller.appwriteRoom.isUserAdmin) ? "Delete Room" : "Leave Room",
                            style:  TextStyle(color: Colors.black87,fontSize: 0.0085 * Get.height + 0.017 * Get.width),
=======
                            (controller.appwriteRoom.isUserAdmin)
                                ? "Delete Room"
                                : "Leave Room",
                            style: const TextStyle(color: Colors.black87),
>>>>>>> a31f6c08e59d7fb322d7f66ba2f74839f01d3936
                          )),
                        ),
                      ),
                      GetBuilder<SingleRoomController>(builder: (controller) {
<<<<<<< HEAD
                        return (controller.me.value.isSpeaker) ? SizedBox(
                                      height: 0.06815 * Get.height,
            width: 0.1361 * Get.width,
                          child: FloatingActionButton(
                            onPressed: () =>
                                (controller.me.value.isMicOn) ? controller.turnOffMic() : controller.turnOnMic(),
                            backgroundColor: (controller.me.value.isMicOn) ? Colors.lightGreen : Colors.redAccent,
                            child: Icon(
                              (controller.me.value.isMicOn) ? Icons.mic : Icons.mic_off,
                              color: Colors.black,
                              size: 0.0146*Get.height+0.029*Get.width,
                            ),
                          ),
                        ) : SizedBox(
                                      height: 0.06815 * Get.height,
            width: 0.1361 * Get.width,
                          child: FloatingActionButton(
                            onPressed: () => (controller.me.value.hasRequestedToBeSpeaker) ? controller.unRaiseHand() : controller.raiseHand(),
                            backgroundColor: (controller.me.value.hasRequestedToBeSpeaker) ? Colors.amber : Colors.black54,
                            child: Icon(
                              (controller.me.value.hasRequestedToBeSpeaker) ? Icons.back_hand : Icons.back_hand_outlined,
                              color: (controller.me.value.hasRequestedToBeSpeaker) ? Colors.black : Colors.amber,
                              size: 0.0146*Get.height+0.029*Get.width,
                            ),
                          ),
                        );
=======
                        return (controller.me.value.isSpeaker)
                            ? FloatingActionButton(
                                onPressed: () => (controller.me.value.isMicOn)
                                    ? controller.turnOffMic()
                                    : controller.turnOnMic(),
                                backgroundColor: (controller.me.value.isMicOn)
                                    ? Colors.lightGreen
                                    : Colors.redAccent,
                                child: Icon(
                                  (controller.me.value.isMicOn)
                                      ? Icons.mic
                                      : Icons.mic_off,
                                  color: Colors.black,
                                ),
                              )
                            : FloatingActionButton(
                                onPressed: () => (controller
                                        .me.value.hasRequestedToBeSpeaker)
                                    ? controller.unRaiseHand()
                                    : controller.raiseHand(),
                                backgroundColor: (controller
                                        .me.value.hasRequestedToBeSpeaker)
                                    ? Colors.amber
                                    : Colors.black54,
                                child: Icon(
                                  (controller.me.value.hasRequestedToBeSpeaker)
                                      ? Icons.back_hand
                                      : Icons.back_hand_outlined,
                                  color: (controller
                                          .me.value.hasRequestedToBeSpeaker)
                                      ? Colors.black
                                      : Colors.amber,
                                ),
                              );
>>>>>>> a31f6c08e59d7fb322d7f66ba2f74839f01d3936
                      }),
                      Container(
                          height: 0.0486*Get.height,
                          width: 0.3*Get.width,
                        decoration: const BoxDecoration(
                            gradient: AppColor.gradientBg,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Center(child: Obx(() {
                          return Text(
                            "${controller.participants.length}+ Active",
<<<<<<< HEAD
                            style: TextStyle(color: Colors.black87, fontSize:   0.0085 * Get.height + 0.017 * Get.width),
=======
                            style: const TextStyle(color: Colors.black87),
>>>>>>> a31f6c08e59d7fb322d7f66ba2f74839f01d3936
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
