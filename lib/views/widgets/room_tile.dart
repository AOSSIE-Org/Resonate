//import required packages
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
  final AppwriteRoom
      room; //RoomTile requires an instance of AppwriteRoom named room

  RoomTile({super.key, required this.room});
  //buildTags is a function which returns a tagString
  //tagString obtains its value from the `List of tags` of AppwriteRoom named room.
  Text buildTags() {
    String tagString = "";
    if (room.tags.isNotEmpty) {
      // this fixes error for rooms without tags
      tagString = room.tags[0]; // fixes error accessing a nonexistent index

      for (var tag in room.tags.sublist(1)) {
        tagString +=
            " · $tag"; //tagString appends every single tag from List of tags
      }
    }
    return Text(
      tagString,
      style: kTileSubtitleStyle,
    );
  }

  //roomStateText function returns a specific string value based on the `state` parameter of room
  //the `state` parameter defined in AppwriteRoom is of type RoomState enum.
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

  //roomStateIcon returns a different icon based on the value of `state` of room.
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

  //kTileTitleStyle is a predefined TextStyle for title of RoomTile.
  var kTileTitleStyle = TextStyle(
      fontSize: UiSizes.size_23,
      fontWeight: FontWeight.w500,
      color: Colors.black);
//kTileSubtitleStyle is a predefined TextStyle for subtitle of RoomTile.
  var kTileSubtitleStyle = TextStyle(
      fontSize: UiSizes.size_15,
      fontWeight: FontWeight.w100,
      color: Colors.black54);

  @override
  Widget build(BuildContext context) {
    return Container(
      //define a margin of container.
      //decoration and child will only be visible inside the magrin and not on the margin.
      margin: EdgeInsets.symmetric(
        vertical: UiSizes.height_10,
        horizontal: UiSizes.width_10,
      ),
      //customize the container
      decoration: BoxDecoration(
        //use gradientBg of AppColor which creates a linear gradient
        gradient: AppColor.gradientBg,
        //makes the edges of container more rounded
        borderRadius: BorderRadius.all(
          Radius.circular(
            UiSizes.size_15,
          ),
        ),
      ),
      child: Column(
        children: [
          //Make the RoomTile tappable
          InkWell(
            onTap: () async {
              await Get.find<RoomsController>().joinRoom(room: room);
            },
            child: Container(
              //padding uses extra space inside the container
              //child widgets are constrained if padding is used.
              padding: EdgeInsets.symmetric(
                vertical: UiSizes.height_10,
                horizontal: UiSizes.width_10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      //use roomStateIcon() function to get icon based on `state` of AppwriteRoom named room
                      FaIcon(
                        roomStateIcon(),
                        color: Colors.green,
                        size: UiSizes.size_20,
                      ),
                      //Seperation
                      SizedBox(
                        width: UiSizes.width_5,
                      ),
                      //Display text returned by roomStateText() and use predefined kTileSubtitleStyle to style the text
                      Text(roomStateText(), style: kTileSubtitleStyle),
                      //Spacer creates a flexible space.
                      const Spacer(),
                      //use ellipsis icon at the end of RoomTile
                      const FaIcon(
                        FontAwesomeIcons.ellipsis,
                        color: Colors.black,
                      ),
                    ],
                  ),
                  //Seperation
                  SizedBox(
                    height: UiSizes.width_5,
                  ),
                  //Display the room name
                  Text(
                    room.name,
                    maxLines: 3,
                    style: kTileTitleStyle,
                  ),
                  //Seperation
                  SizedBox(
                    height: UiSizes.height_4,
                  ),
                  //Display the tags specified in room
                  buildTags(),
                  //Seperation
                  SizedBox(
                    height: UiSizes.width_5,
                  ),
                ],
              ),
            ),
          ),
          //creates a Container which is used to display the avatars of members joined in an AppwriteRoom
          Container(
            //customize the container
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.all(
                Radius.circular(UiSizes.size_15),
              ),
            ),
            padding: EdgeInsets.symmetric(
                vertical: UiSizes.height_10, horizontal: UiSizes.width_20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    //add a whitespace before the row
                    SizedBox(
                      width: UiSizes.width_8,
                    ),
                    //render avatars of list of members which are present in a room
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
                    //seperation
                    SizedBox(
                      width: UiSizes.width_16,
                    ),
                    //display the total participants joined in a room
                    Text("${room.totalParticipants}+ Joined",
                        style: kTileSubtitleStyle),
                    //add a flexible space
                    const Spacer(),
                    //display a like(thumbsUp) icon
                    FaIcon(
                      FontAwesomeIcons.thumbsUp,
                      color: Colors.black,
                      size: UiSizes.size_16,
                    ),
                    //seperation
                    SizedBox(
                      width: UiSizes.width_16,
                    ),
                    //create a share icon which when tapped will create a roomLink and allow user to share it
                    GestureDetector(
                      child: Icon(
                        Icons.share,
                        color: Colors.black,
                        size: UiSizes.size_16,
                      ),
                      onTap: () {
                        String roomLink =
                            "https://resonate.aossie.org/room/${room.id}";
                        //Share class provided by share_plus package displays a share sheet which facilitate room link sharing
                        Share.share(
                          '🎉 Let\'s Resonate 🎉\n'
                          '🎙️ Room Topic: ${room.name}\n'
                          '🔗 Link: $roomLink\n',
                        );
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
