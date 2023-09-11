import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/single_room_controller.dart';
import 'package:resonate/utils/ui_sizes.dart';

import '../../models/participant.dart';

class ParticipantBlock extends StatelessWidget {
  ParticipantBlock({
    super.key,
    required this.participant,
    required this.controller,
  });

  final Participant participant;
  SingleRoomController controller;

  String getUserRole() {
    if (participant.isAdmin) {
      return "Admin";
    } else if (participant.isModerator) {
      return "Moderator";
    } else if (participant.isSpeaker) {
      return "Speaker";
    } else {
      return "Listener";
    }
  }

  @override
  Widget build(BuildContext context) {
    return FocusedMenuHolder(
      onPressed: () {},
      menuItemExtent: UiSizes.width_45,
      menuWidth: UiSizes.width_180,
      menuBoxDecoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(
          color: Colors.amber,
          width: UiSizes.width_1,
        ),
      ),
      duration: const Duration(milliseconds: 100),
      animateMenuItems: true,
      blurBackgroundColor: Colors.black54,
      menuItems: (controller.me.value.isAdmin)
          ? (participant.isAdmin)
              ? []
              : [
                  if (participant.hasRequestedToBeSpeaker)
                    FocusedMenuItem(
                        title: Text(
                          "Add Speaker",
                          style: TextStyle(
                              color: Colors.amber, fontSize: UiSizes.size_14),
                        ),
                        trailingIcon: Icon(
                          Icons.record_voice_over,
                          color: Colors.green,
                          size: UiSizes.size_18,
                        ),
                        onPressed: () {
                          controller.makeSpeaker(participant);
                        },
                        backgroundColor: Colors.black),
                  if (participant.isSpeaker)
                    FocusedMenuItem(
                        title: Text(
                          "Make Listener",
                          style: TextStyle(
                              color: Colors.amber, fontSize: UiSizes.size_14),
                        ),
                        trailingIcon: Icon(
                          Icons.mic_off_sharp,
                          color: Colors.red,
                          size: UiSizes.size_18,
                        ),
                        onPressed: () {
                          controller.makeListener(participant);
                        },
                        backgroundColor: Colors.black),
                  FocusedMenuItem(
                      title: Text(
                        "Kick Out",
                        style: TextStyle(
                            color: Colors.amber, fontSize: UiSizes.size_14),
                      ),
                      trailingIcon: Icon(
                        Icons.remove_circle_outline,
                        color: Colors.red,
                        size: UiSizes.size_18,
                      ),
                      onPressed: () {
                        controller.kickOutParticipant(participant);
                      },
                      backgroundColor: Colors.black),
                ]
          : [],
      openWithTap:
          (controller.me.value.isAdmin && !participant.isAdmin) ? true : false,
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: UiSizes.height_2, horizontal: UiSizes.width_2),
        alignment: Alignment.center,
        child: Column(
          children: [
            CircleAvatar(
              radius: UiSizes.size_32,
              backgroundColor: Colors.amber,
              child: CircleAvatar(
                backgroundImage: NetworkImage(participant.dpUrl),
                radius: UiSizes.size_30,
                child: (participant.hasRequestedToBeSpeaker)
                    ? Stack(
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: Icon(
                              Icons.waving_hand_rounded,
                              color: Colors.amber,
                              size: UiSizes.size_20,
                            ),
                          ),
                        ],
                      )
                    : null,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (participant.isSpeaker)
                  Icon(
                    (participant.isMicOn) ? Icons.mic : Icons.mic_off,
                    color: (participant.isMicOn)
                        ? Colors.lightGreenAccent
                        : Colors.red,
                    size: UiSizes.size_16,
                  ),
                Text(
                  participant.name.split(' ').first,
                  style:
                      TextStyle(color: Colors.white, fontSize: UiSizes.size_16),
                ),
              ],
            ),
            Text(
              getUserRole(),
              style: TextStyle(color: Colors.grey, fontSize: UiSizes.size_14),
            )
          ],
        ),
      ),
    );
  }
}
