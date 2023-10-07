import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/controllers/single_room_controller.dart';
import 'package:resonate/models/appwrite_room.dart';
import 'package:resonate/utils/ui_sizes.dart';
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
      padding: EdgeInsets.symmetric(horizontal: UiSizes.width_16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: UiSizes.height_15),
              height: UiSizes.height_7,
              width: UiSizes.height_80,
              decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.5),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
            ),
          ),
          SizedBox(
            height: UiSizes.height_12,
          ),
          Row(
            children: [
              Text(
                widget.room.name,
                style: TextStyle(
                  fontSize: UiSizes.size_20,
                  color: Colors.amber,
                ),
              ),
              const Spacer(),
              FaIcon(
                FontAwesomeIcons.ellipsis,
                color: Colors.amber,
                size: UiSizes.size_24,
              ),
            ],
          ),
          SizedBox(
            height: UiSizes.height_8,
          ),
          Text(getTags(),
              style: TextStyle(
                fontSize: UiSizes.size_15,
                fontWeight: FontWeight.w100,
              )),
          SizedBox(
            height: UiSizes.height_7,
          ),
          Text(
            widget.room.description,
            style: TextStyle(
              color: Colors.grey,
              fontSize: UiSizes.size_14,
            ),
          ),
          SizedBox(
            height: UiSizes.height_7,
          ),
          Divider(
            thickness: UiSizes.height_2,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: UiSizes.height_5),
              child: Obx(() {
                return (!controller.isLoading.value)
                    ? GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: UiSizes.width_20,
                          mainAxisSpacing: UiSizes.height_5,
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
            thickness: UiSizes.height_2,
          ),
          SafeArea(
            child: SizedBox(
              height: UiSizes.height_66,
              child: Column(
                children: [
                  SizedBox(
                    height: UiSizes.height_8,
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
                          height: UiSizes.height_40,
                          width: UiSizes.width_123_4,
                          decoration: const BoxDecoration(
                              gradient: AppColor.gradientBg,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Center(
                              child: Text(
                            (controller.appwriteRoom.isUserAdmin)
                                ? "Delete Room"
                                : "Leave Room",
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: UiSizes.size_14),
                          )),
                        ),
                      ),
                      GetBuilder<SingleRoomController>(builder: (controller) {
                        return (controller.me.value.isSpeaker)
                            ? SizedBox(
                                height: UiSizes.height_56,
                                width: UiSizes.width_56,
                                child: FloatingActionButton(
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
                                    size: UiSizes.size_24,
                                  ),
                                ),
                              )
                            : SizedBox(
                                height: UiSizes.height_56,
                                width: UiSizes.width_56,
                                child: FloatingActionButton(
                                  onPressed: () => (controller
                                          .me.value.hasRequestedToBeSpeaker)
                                      ? controller.unRaiseHand()
                                      : controller.raiseHand(),
                                  backgroundColor: (controller
                                          .me.value.hasRequestedToBeSpeaker)
                                      ? Colors.amber
                                      : Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black54,
                                  child: Icon(
                                    (controller
                                            .me.value.hasRequestedToBeSpeaker)
                                        ? Icons.back_hand
                                        : Icons.back_hand_outlined,
                                    color: (controller
                                            .me.value.hasRequestedToBeSpeaker)
                                        ? Colors.black
                                        : Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.black
                                            : Colors.white54,
                                    size: UiSizes.size_24,
                                  ),
                                ),
                              );
                      }),
                      Container(
                        height: UiSizes.height_40,
                        width: UiSizes.width_123_4,
                        decoration: const BoxDecoration(
                            gradient: AppColor.gradientBg,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Center(child: Obx(() {
                          return Text(
                            "${controller.participants.length}+ Active",
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: UiSizes.size_14),
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
