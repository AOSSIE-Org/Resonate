import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/rooms_controller.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:share_plus/share_plus.dart';

import '../../models/appwrite_room.dart';
import '../../utils/colors.dart';
import '../../utils/enums/room_state.dart';

class RoomTile extends StatelessWidget {
  final AppwriteRoom room;

  RoomTile({super.key, required this.room});

  Text buildTags() {
    String tagString = "";
    if (room.tags.isNotEmpty) {
      // this fixes error for rooms without tags
      tagString = room.tags[0]; // fixes error accessing a nonexistent index

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
      fontSize: UiSizes.size_23,
      fontWeight: FontWeight.w500,
      color: Colors.black);

  var kTileSubtitleStyle = TextStyle(
      fontSize: UiSizes.size_15,
      fontWeight: FontWeight.w100,
      color: Colors.black54);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: UiSizes.height_10, horizontal: UiSizes.width_10),
      decoration: BoxDecoration(
          gradient: AppColor.gradientBg,
          borderRadius: BorderRadius.all(Radius.circular(UiSizes.size_15))),
      child: Column(
        children: [
          InkWell(
            onTap: () async {
              await Get.find<RoomsController>().joinRoom(room: room);
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: UiSizes.height_10, horizontal: UiSizes.width_10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      FaIcon(
                        roomStateIcon(),
                        color: Colors.green,
                        size: UiSizes.size_20,
                      ),
                      SizedBox(
                        width: UiSizes.width_5,
                      ),
                      Text(roomStateText(), style: kTileSubtitleStyle),
                      const Spacer(),
                      const FaIcon(
                        FontAwesomeIcons.ellipsis,
                        color: Colors.black,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: UiSizes.width_5,
                  ),
                  Text(
                    room.name,
                    maxLines: 3,
                    style: kTileTitleStyle,
                  ),
                  SizedBox(
                    height: UiSizes.height_4,
                  ),
                  buildTags(),
                  SizedBox(
                    height: UiSizes.width_5,
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius:
                    BorderRadius.all(Radius.circular(UiSizes.size_15))),
            padding: EdgeInsets.symmetric(
                vertical: UiSizes.height_10, horizontal: UiSizes.width_20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: UiSizes.width_8,
                    ),
                    for (var avatarImageUrl in room.memberAvatarUrls)
                      Align(
                        widthFactor: 0.5,
                        child: CircleAvatar(
                          radius: UiSizes.size_19,
                          backgroundColor:
                              const Color.fromRGBO(230, 171, 49, 1),
                          child: CircleAvatar(
                            radius: UiSizes.size_15,
                            backgroundImage: NetworkImage(avatarImageUrl),
                          ),
                        ),
                      ),
                    SizedBox(
                      width: UiSizes.width_16,
                    ),
                    Text("${room.totalParticipants}+ Joined",
                        style: kTileSubtitleStyle),
                    const Spacer(),
                    FaIcon(
                      FontAwesomeIcons.thumbsUp,
                      color: Colors.black,
                      size: UiSizes.size_16,
                    ),
                    SizedBox(
                      width: UiSizes.width_16,
                    ),
                    GestureDetector(
                      child: Icon(
                        Icons.share,
                        color: Colors.black,
                        size: UiSizes.size_16,
                      ),
                      onTap: () {
                        String roomLink =
                            "https://resonate.aossie.org/room/${room.id}";
                        Share.share('🎉 Let\'s Resonate 🎉\n'
                            '🎙️ Room Topic: ${room.name}\n'
                            '🔗 Link: $roomLink\n');
                      },
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
