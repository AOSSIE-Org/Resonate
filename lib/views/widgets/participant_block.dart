import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:resonate/controllers/single_room_controller.dart';
import 'package:resonate/utils/ui_sizes.dart';

import '../../models/participant.dart';

class FocusedMenuItemData {
  final String textContent;
  final Function action;

  FocusedMenuItemData(this.textContent, this.action);
}

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

  List<FocusedMenuItem> makeMenuItems(
      List<FocusedMenuItemData> items, Brightness currentBrightness) {
    return items
        .map(
          (item) => FocusedMenuItem(
            title: Text(
              item.textContent,
              style: TextStyle(
                color: Colors.amber,
                fontSize: UiSizes.size_14,
              ),
            ),
            trailingIcon: Icon(
              Icons.remove_circle_outline,
              color: Colors.red,
              size: UiSizes.size_18,
            ),
            onPressed: item.action,
            backgroundColor: currentBrightness == Brightness.light
                ? Colors.white
                : Colors.black,
          ),
        )
        .toList();
  }

  List<FocusedMenuItem> getMenuItems(Brightness currentBrightness) {
    if ((!controller.me.value.isAdmin && !controller.me.value.isModerator) ||
        participant.isAdmin) {
      return [];
    }

    if (controller.me.value.isAdmin) {
      if (participant.isModerator) {
        return makeMenuItems([
          FocusedMenuItemData(
            "Remove Moderator",
            () {
              controller.removeModerator(participant);
            },
          ),
          FocusedMenuItemData(
            "Kick Out",
            () {
              controller.kickOutParticipant(participant);
            },
          )
        ], currentBrightness);
      } else {
        return makeMenuItems([
          FocusedMenuItemData("Add Moderator", () {
            controller.makeModerator(participant);
          }),
          if (participant.hasRequestedToBeSpeaker)
            FocusedMenuItemData("Add Speaker", () {
              controller.makeSpeaker(participant);
            }),
          if (participant.isSpeaker)
            FocusedMenuItemData("Make Listener", () {
              controller.makeListener(participant);
            }),
          FocusedMenuItemData(
            "Kick Out",
            () {
              controller.kickOutParticipant(participant);
            },
          ),
        ], currentBrightness);
      }
    }

    if (controller.me.value.isModerator) {
      if (participant.isModerator) {
        return [];
      } else {
        return makeMenuItems([
          if (participant.hasRequestedToBeSpeaker)
            FocusedMenuItemData("Add Speaker", () {
              controller.makeSpeaker(participant);
            }),
          if (participant.isSpeaker)
            FocusedMenuItemData("Make Listener", () {
              controller.makeListener(participant);
            }),
          FocusedMenuItemData(
            "Kick Out",
            () {
              controller.kickOutParticipant(participant);
            },
          ),
        ], currentBrightness);
      }
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    Brightness currentBrightness = Theme.of(context).brightness;

    return FocusedMenuHolder(
      onPressed: () {},
      menuItemExtent: UiSizes.width_45,
      menuWidth: UiSizes.width_200 * 1.05,
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
      blurBackgroundColor: currentBrightness == Brightness.light
          ? Colors.white54
          : Colors.black54,
      menuItems: getMenuItems(currentBrightness),
      openWithTap: ((controller.me.value.isAdmin ||
                  (controller.me.value.isModerator &&
                      !participant.isModerator)) &&
              !participant.isAdmin)
          ? true
          : false,
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (participant.isSpeaker)
                    Icon(
                      (participant.isMicOn) ? Icons.mic : Icons.mic_off,
                      color: (participant.isMicOn)
                          ? Colors.lightGreen
                          : Colors.red,
                      size: UiSizes.size_16,
                    ),
                  Text(
                    participant.name.split(' ').first,
                    style: TextStyle(
                      fontSize: UiSizes.size_16,
                    ),
                  )
                ],
              ),
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
