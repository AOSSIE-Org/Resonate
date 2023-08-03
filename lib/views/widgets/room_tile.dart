import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/rooms_controller.dart';

import '../../models/appwrite_room.dart';
import '../../utils/colors.dart';
import '../../utils/enums/room_state.dart';

class RoomTile extends StatelessWidget {
  final AppwriteRoom room;

  RoomTile({required this.room});

  Text buildTags() {
    String tagString = room.tags.isNotEmpty ? room.tags[0] : "";
    if (room.tags.isNotEmpty) {
      for (var tag in room.tags.sublist(1)) {
        tagString += " · $tag";
      }
    }
    return Text(
      tagString,
      style: kTileSubtitleStyle,
    );
  }

  String roomStateText() {
    switch (room.state) {
      case RoomState.live:
        return "Happening Now";
      case RoomState.scheduled:
        return "Scheduled";
      case RoomState.recorded:
        return "Recorded";
    }
  }

  IconData roomStateIcon() {
    switch (room.state) {
      case RoomState.live:
        return Icons.play_circle_outline_rounded;
      case RoomState.scheduled:
        return Icons.calendar_month;
      case RoomState.recorded:
        return Icons.record_voice_over_outlined;
    }
  }

  var kTileTitleStyle = TextStyle(
      fontSize: 0.01399 * Get.height + 0.02795 * Get.width,
      fontWeight: FontWeight.w500,
      color: Colors.black);

  var kTileSubtitleStyle = TextStyle(
      fontSize: 0.0182 * Get.width + 0.009127 * Get.height,
      fontWeight: FontWeight.w100,
      color: Colors.black54);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: 0.012 * Get.height, horizontal: 0.024 * Get.width),
      decoration: BoxDecoration(
          gradient: AppColor.gradientBg,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Column(
        children: [
          InkWell(
            onTap: () async {
              await Get.find<RoomsController>().joinRoom(room: room);
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: 0.012 * Get.height, horizontal: 0.024 * Get.width),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      FaIcon(
                        roomStateIcon(),
                        color: Colors.green,
                        size: 0.012 * Get.height + 0.024 * Get.width,
                      ),
                      SizedBox(
                        width: Get.width * 0.01,
                      ),
                      Text(roomStateText(), style: kTileSubtitleStyle),
                      Spacer(),
                      FaIcon(
                        FontAwesomeIcons.ellipsis,
                        color: Colors.black,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Get.height * 0.01,
                  ),
                  Text(
                    room.name,
                    maxLines: 3,
                    style: kTileTitleStyle,
                  ),
                  SizedBox(
                    height: Get.height * 0.005,
                  ),
                  buildTags(),
                  SizedBox(
                    height: Get.height * 0.01,
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.black12,
            padding: EdgeInsets.symmetric(
                vertical: 0.012 * Get.height, horizontal: 0.024 * Get.width),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: Get.width * 0.02,
                    ),
                    for (var avatarImageUrl in room.memberAvatarUrls)
                      Align(
                        widthFactor: 0.5,
                        child: CircleAvatar(
                          radius: 19,
                          backgroundColor: Color.fromRGBO(230, 171, 49, 1),
                          child: CircleAvatar(
                            radius: 15,
                            backgroundImage: NetworkImage(avatarImageUrl),
                          ),
                        ),
                      ),
                    SizedBox(
                      width: Get.width * 0.04,
                    ),
                    Text("${room.totalParticipants}+ Joined",
                        style: kTileSubtitleStyle),
                    Spacer(),
                    FaIcon(
                      FontAwesomeIcons.thumbsUp,
                      color: Colors.black,
                      size: 0.02187 * Get.width + 0.01095 * Get.height,
                    ),
                    SizedBox(
                      width: Get.width * 0.04,
                    ),
                    Icon(
                      Icons.share,
                      color: Colors.black,
                      size: 0.02187 * Get.width + 0.01095 * Get.height,
                    ),
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
