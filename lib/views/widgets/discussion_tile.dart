import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/discussions_controller.dart';
import 'package:resonate/themes/theme_controller.dart';
import 'package:resonate/utils/ui_sizes.dart';

class DiscussionTile extends StatelessWidget {
  final Document discussion;
  final String subscriberCount;
  final bool? userIsCreator;
  final String? userSubscriberId;
  final List<String> subscriberProfileUrl;
  DiscussionsController discussionController =
      Get.find<DiscussionsController>();
  final ThemeController themeController = Get.find<ThemeController>();
  DiscussionTile(
      {super.key,
      required this.discussion,
      required this.subscriberCount,
      required this.userIsCreator,
      required this.subscriberProfileUrl,
      required this.userSubscriberId});
  Text buildTags() {
    String tagString = "";
    if (discussion.data["tags"].isNotEmpty) {
      // this fixes error for rooms without tags
      tagString = discussion.data["tags"]
          [0]; // fixes error accessing a nonexistent index

      for (var tag in discussion.data["tags"].sublist(1)) {
        tagString += "  ·  $tag";
      }
    }
    return Text(
      tagString,
      style: kTileSubtitleStyle,
    );
  }

  Row buildDateTimeToReadableFormat() {
    String dateTime = discussion.data["scheduledDateTime"];
    List<String> splittedStrings = dateTime.split("T");
    String date = splittedStrings[0];
    String time = splittedStrings[1];
    List<String> exploreDate = date.split("-");
    List<String> exploreTime = time.split(":");
    String year = exploreDate[0];
    String day = exploreDate[2];
    String month = exploreDate[1];
    int hour = int.parse(exploreTime[0]);
    String minute = exploreTime[1];
    DateTime uTCDateTime = DateTime(int.parse(year), int.parse(month),
        int.parse(day), hour, int.parse(minute));
    DateTime localDateTime = discussionController.isOffsetNegetive
        ? uTCDateTime.subtract(discussionController.localTimeZoneOffset)
        : uTCDateTime.add(discussionController.localTimeZoneOffset);
    String monthName =
        discussionController.monthMap[localDateTime.month.toString()]!;

    hour = localDateTime.hour;
    late String formattedTime;
    if (hour >= 12) {
      formattedTime =
          '${hour != 12 ? (hour - 12) : hour}:${localDateTime.minute.toString().length < 2 ? '0${localDateTime.minute}' : localDateTime.minute} PM  ${discussionController.localTimeZoneName}';
    } else {
      formattedTime =
          '${hour == 0 ? '00' : hour}:${localDateTime.minute.toString().length < 2 ? '0${localDateTime.minute}' : localDateTime.minute} AM  ${discussionController.localTimeZoneName}';
    }
    return Row(
      children: [
        Text(
          '${localDateTime.day} ${monthName}',
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
  var kTileDescriptionStyle = TextStyle(
      fontSize: UiSizes.size_13,
      fontWeight: FontWeight.w100,
      color: const Color.fromARGB(100, 0, 0, 0));

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: UiSizes.height_10, horizontal: UiSizes.width_10),
      decoration: BoxDecoration(
          gradient: themeController.createDynamicGradient(),
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
                    Expanded(
                      child: Text(
                        discussion.data["name"],
                        maxLines: 3,
                        style: kTileTitleStyle,
                      ),
                    ),
                    Row(
                      children: [
                        userIsCreator == null
                            ? const SizedBox.shrink()
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
                                : const SizedBox(),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                disabledBackgroundColor:
                                    const Color.fromARGB(183, 120, 118, 118),
                                side: BorderSide(
                                    color: userIsCreator == null
                                        ? themeController.primaryColor.value
                                        : (userIsCreator! &
                                                !discussion.data['isTime'])
                                            ? Colors.black
                                            : themeController.loadTheme() ==
                                                    'dark'
                                                ? Colors.white
                                                : Colors.black,
                                    width: 1),
                                backgroundColor: userIsCreator == null
                                    ? Colors.black
                                    : (!userIsCreator!)
                                        ? const Color.fromARGB(155, 58, 190, 34)
                                        : themeController.loadTheme() == 'dark'
                                            ? const Color.fromARGB(
                                                51, 0, 143, 0)
                                            : const Color.fromARGB(
                                                220, 229, 248, 229),
                                minimumSize:
                                    Size(UiSizes.width_80, UiSizes.height_30),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            onPressed: userIsCreator == null
                                ? () async {
                                    await discussionController
                                        .addUserToSubscriberList(
                                            discussion.$id);
                                    await discussionController
                                        .getDiscussions();
                                  }
                                : !userIsCreator!
                                    ? () async {
                                        await discussionController
                                            .removeUserFromSubscriberList(
                                                userSubscriberId!);
                                        await discussionController
                                            .getDiscussions();
                                      }
                                    : userIsCreator! & discussion.data['isTime']
                                        ? () {
                                            // Start the Room as User is Creator
                                            List<String> tags = [];
                                            for (var tag
                                                in discussion.data["tags"]) {
                                              tags.add(tag.toString());
                                            }
                                            discussionController
                                                .convertDiscussiontoRoom(
                                                    discussion.$id,
                                                    discussion.data["name"],
                                                    discussion
                                                        .data["description"],
                                                    tags);
                                          }
                                        : null,
                            child: Text(
                                userIsCreator == null
                                    ? "Subscribe"
                                    : userIsCreator!
                                        ? "Start"
                                        : "Unsubscribe",
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: UiSizes.size_14,
                                  color: userIsCreator! &
                                          !discussion.data['isTime']
                                      ? Colors.black
                                      : themeController.loadTheme() == 'dark'
                                          ? Colors.white
                                          : Colors.black,
                                  fontWeight: FontWeight.w100,
                                ))),
                        userIsCreator == null
                            ? const SizedBox()
                            : userIsCreator!
                                ? Row(
                                    children: [
                                      SizedBox(
                                        width: UiSizes.width_8,
                                      ),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              side: const BorderSide(
                                                  color: Color.fromARGB(
                                                      198, 100, 8, 3),
                                                  width: 1),
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      246, 243, 81, 81),
                                              minimumSize: Size(
                                                  UiSizes.width_80,
                                                  UiSizes.height_30),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20))),
                                          onPressed: () {
                                            Get.defaultDialog(
                                              title: "Are you sure?",
                                              middleText:
                                                  "You want to delete this Discussion",
                                              textConfirm: "Yes",
                                              buttonColor: themeController
                                                  .primaryColor.value,
                                              confirmTextColor: Colors.white,
                                              cancelTextColor: themeController
                                                  .primaryColor.value,
                                              textCancel: "No",
                                              contentPadding: EdgeInsets.all(
                                                  UiSizes.size_15),
                                              onConfirm: () async {
                                                await discussionController
                                                    .deleteDiscussion(
                                                        discussion.$id);
                                                Navigator.pop(context);
                                              },
                                            );
                                          },
                                          child: Text("Cancel",
                                              style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                color: Colors.black,
                                                fontSize: UiSizes.size_14,
                                                fontWeight: FontWeight.w100,
                                              )))
                                    ],
                                  )
                                : const SizedBox(),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: UiSizes.height_4,
                ),
                buildTags(),
                discussion.data["description"] == null
                    ? const SizedBox()
                    : Column(
                        children: [
                          SizedBox(
                            height: UiSizes.height_10,
                          ),
                          Text(
                            discussion.data["description"],
                            style: kTileDescriptionStyle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ],
                      ),
                SizedBox(
                  height: UiSizes.height_4,
                )
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
                        child: Stack(
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  themeController.primaryColor.value,
                              radius: UiSizes.size_19,
                            ),
                            Positioned(
                              left: UiSizes.width_2,
                              top: UiSizes.height_2,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: UiSizes.size_16,
                                backgroundImage: NetworkImage(avatarImageUrl),
                              ),
                            ),
                          ],
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
