import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../utils/colors.dart';
import '../../utils/enums/room_state.dart';

class RoomTile extends StatelessWidget {
  final String roomName;
  final List<String> tags;
  final RoomState roomState;
  final List<String> memberAvatarUrls;
  final int totalActiveMembers;
  RoomTile(
      {required this.roomName,
      required this.tags,
      required this.roomState,
      required this.memberAvatarUrls,
      required this.totalActiveMembers});

  Text buildTags() {
    String tagString = tags[0] ?? "";
    for (var tag in tags.sublist(1)) {
      tagString += " · $tag";
    }
    return Text(
      tagString,
      style: kTileSubtitleStyle,
    );
  }

  String roomStateText() {
    switch (roomState) {
      case RoomState.live:
        return "Happening Now";
      case RoomState.scheduled:
        return "Scheduled";
      case RoomState.recorded:
        return "Recorded";
    }
  }

  IconData roomStateIcon() {
    switch (roomState) {
      case RoomState.live:
        return Icons.play_circle_outline_rounded;
      case RoomState.scheduled:
        return Icons.calendar_month;
      case RoomState.recorded:
        return Icons.record_voice_over_outlined;
    }
  }

  var kTileTitleStyle = const TextStyle(
      fontSize: 23, fontWeight: FontWeight.w500, color: Colors.black);

  var kTileSubtitleStyle = const TextStyle(
      fontSize: 15, fontWeight: FontWeight.w100, color: Colors.black54);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
          gradient: AppColor.gradientBg,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    FaIcon(
                      roomStateIcon(),
                      color: Colors.green,
                      size: 20,
                    ),
                    SizedBox(
                      width: Get.width*0.01,
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
                  roomName,
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
          Container(
            color: Colors.black12,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: Get.width*0.02,
                    ),
                    for (var avatarImageUrl in memberAvatarUrls)
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
                      width: Get.width*0.04,
                    ),
                    Text("$totalActiveMembers+ Joined",
                        style: kTileSubtitleStyle),
                    Spacer(),
                    FaIcon(
                      FontAwesomeIcons.thumbsUp,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: Get.width*0.04,
                    ),
                    Icon(
                      Icons.share,
                      color: Colors.black,
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
