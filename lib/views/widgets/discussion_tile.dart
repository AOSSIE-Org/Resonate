import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/discussions_controller.dart';
import 'package:resonate/controllers/rooms_controller.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:share_plus/share_plus.dart';
import '../../utils/colors.dart';
import '../../utils/enums/room_state.dart';

class DiscussionTile extends StatelessWidget {
  final Document discussion;
  final String subscriberCount;
  final bool? userIsCreator;
  final String? subscriberId;
  final List<String> subscriberProfileUrl;
  DiscussionsController disscussionController =
      Get.find<DiscussionsController>();
  DiscussionTile(
      {super.key,
      required this.discussion,
      required this.subscriberCount,
      required this.userIsCreator,
      required this.subscriberProfileUrl,
      required this.subscriberId});
  Text buildTags() {
    String tagString = "";
    if (discussion.data["Tags"].isNotEmpty) {
      // this fixes error for rooms without tags
      tagString = discussion.data["Tags"]
          [0]; // fixes error accessing a nonexistent index

      for (var tag in discussion.data["Tags"].sublist(1)) {
        tagString += "  ·  $tag";
      }
    }
    return Text(
      tagString,
      style: kTileSubtitleStyle,
    );
  }

  Row buildDateTimeToReadableFormat() {
    String dateTime = discussion.data["ScheduledDateTime"];
    List<String> splittedStrings = dateTime.split("T");
    String date = splittedStrings[0];
    String time = splittedStrings[1];
    List<String> exploreDate = date.split("-");
    List<String> exploreTime = time.split(":");
    String day = exploreDate[2];
    String month = disscussionController.monthMap[exploreDate[1]]!;
    int hour = int.parse(exploreTime[0]);
    String minute = exploreTime[1];
    late String formattedTime;
    if (hour >= 12) {
      if (hour != 12) {
        hour = hour - 12;
      }
      formattedTime = '${hour}:${minute} PM  IST';
    } else {
      formattedTime = '${hour}:${minute} AM  IST';
    }
    print(dateTime);
    print(formattedTime);
    return Row(
      children: [
        Text(
          '${day} ${month}',
          style: kTileSubtitleStyle,
        ),
        SizedBox(
          width: UiSizes.width_10,
        ),
        Text(
          "·",
          style: kTileSubtitleStyle,
        ),
        SizedBox(
          width: UiSizes.width_10,
        ),
        Text(
          formattedTime,
          style: kTileSubtitleStyle,
        ),
      ],
    );
  }

  var kTileTitleStyle = TextStyle(
      fontSize: UiSizes.size_20,
      fontWeight: FontWeight.w500,
      color: Colors.black);

  var kTileSubtitleStyle = TextStyle(
      fontSize: UiSizes.size_14,
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
          Container(
            padding: EdgeInsets.symmetric(
                vertical: UiSizes.height_10, horizontal: UiSizes.width_10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    FaIcon(
                      Icons.calendar_month,
                      color: Colors.green,
                      size: UiSizes.size_20,
                    ),
                    SizedBox(
                      width: UiSizes.width_5,
                    ),
                    Text("Scheduled", style: kTileSubtitleStyle),
                    SizedBox(
                      width: UiSizes.width_10,
                    ),
                    Text(
                      "·",
                      style: kTileSubtitleStyle,
                    ),
                    SizedBox(
                      width: UiSizes.width_10,
                    ),
                    buildDateTimeToReadableFormat(),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      discussion.data["Name"],
                      maxLines: 3,
                      style: kTileTitleStyle,
                    ),
                    Row(
                      children: [
                        userIsCreator == null
                            ? SizedBox.shrink()
                            : !userIsCreator!
                                ? Row(
                                    children: [
                                      Text(
                                        "Subscribed",
                                        style: kTileSubtitleStyle,
                                      ),
                                      SizedBox(
                                        width: UiSizes.width_5,
                                      ),
                                      Text(
                                        "·",
                                        style: kTileSubtitleStyle,
                                      ),
                                      SizedBox(
                                        width: UiSizes.width_5,
                                      ),
                                    ],
                                  )
                                : SizedBox(),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                side: userIsCreator == null
                                    ? BorderSide(
                                        color: Color.fromARGB(198, 60, 244, 28),
                                        width: 1)
                                    : BorderSide(
                                        color:
                                            Color.fromARGB(255, 111, 111, 111),
                                        width: 1),
                                backgroundColor: userIsCreator == null
                                    ? Color.fromARGB(194, 63, 218, 35)
                                    : (!userIsCreator! &
                                            !discussion.data['isLive'])
                                        ? Color.fromARGB(155, 58, 190, 34)
                                        : Color.fromARGB(194, 63, 218, 35),
                                minimumSize:
                                    Size(UiSizes.width_80, UiSizes.height_30),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            onPressed: userIsCreator == null
                                ? () {
                                    disscussionController
                                        .addUserToSubscriberList(
                                            discussion.$id);
                                    disscussionController.getDiscussions();
                                  }
                                : !userIsCreator! & discussion.data['isLive']
                                    ? () {
                                        // Add user to Room
                                      }
                                    : !userIsCreator! &
                                            !discussion.data['isLive']
                                        ? () {
                                            disscussionController
                                                .removeUserFromSubscriberList(
                                                    subscriberId!);
                                            disscussionController
                                                .getDiscussions();
                                          }
                                        : userIsCreator! &
                                                discussion.data['isTime']
                                            ? () {
                                                // Start the Room as User is Creator
                                              }
                                            : null,
                            child: Text(
                                userIsCreator == null
                                    ? "Subscribe"
                                    : userIsCreator!
                                        ? "Start"
                                        : discussion.data['isLive']
                                            ? "Join"
                                            : "Unsubscribe",
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: UiSizes.size_14,
                                  fontWeight: FontWeight.w100,
                                ))),
                      ],
                    )
                  ],
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
                    for (var avatarImageUrl in subscriberProfileUrl)
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
                    Text("${subscriberCount}+ Subscribed",
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
                        // String roomLink =
                        //     "https://resonate.aossie.org/room/${room.id}";
                        // Share.share('🎉 Let\'s Resonate 🎉\n'
                        //     '🎙️ Room Topic: ${room.name}\n'
                        //     '🔗 Link: $roomLink\n');
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
