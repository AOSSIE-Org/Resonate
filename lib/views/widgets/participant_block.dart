//import required files
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:resonate/controllers/single_room_controller.dart';
import 'package:resonate/utils/ui_sizes.dart';

import '../../models/participant.dart';

//FocusedMenuItemData contains the menu items
class FocusedMenuItemData {
  final String textContent;
  final Function action;

  FocusedMenuItemData(this.textContent, this.action);
}

//ParticipantBlock widget has the Ui for participants
class ParticipantBlock extends StatelessWidget {
  ParticipantBlock({
    super.key,
    required this.participant,
    required this.controller,
  });

  final Participant participant; //participant holds data about individual participant defined in lib/models/participant.dart; 
  SingleRoomController controller;//SingleRoomController defines the various actions that a participant can perform like turning on the mic etc.
  //for more info about SingleRoomController check lib/controllers/single_room_controller.dart

  //getUserRole function returns string based on the role of participant 
  String getUserRole() {
    if (participant.isAdmin) { //if the bool isAdmin of Participant class is true return "Admin"
      return "Admin";
    } else if (participant.isModerator) {//if the bool isModerator of Participant class is true return "Moderator"
      return "Moderator";
    } else if (participant.isSpeaker) {//if the bool isSpeaker of Participant class is true return "Speaker"
      return "Speaker";
    } else {
      return "Listener"; //if participant is not admin, moderator or speaker then return "Litener"
    }
  }
  //makeMenuItems builds a list of FocusedMenuItem which is defined in package focused_menu
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
            onPressed: item.action, //call the action specified in FocusedMenuItemData when FocusedMenuItem is pressed
            backgroundColor: currentBrightness == Brightness.light //adjust the backgroundColor based on light and dark mode
                ? Colors.white
                : Colors.black,
          ),
        )
        .toList(); //return a FocusedMenuItem for each item present in List<FocusedMenuItemData> called items
  }
  //getMenuItems function returns a list of FocusedMenuItem
  List<FocusedMenuItem> getMenuItems(Brightness currentBrightness) {
    //`me` is reactive variable of type Participant defined in SingleRoomController
    //if controller's participant(`me`) and participant is not a Admin or Moderator then return an empty list
    if ((!controller.me.value.isAdmin && !controller.me.value.isModerator) ||
        participant.isAdmin) {
      return [];
    }
    //if controller's participant(`me`) and participant is admin then use makeMenuItems to build a list of FocusedMenuItem
    if (controller.me.value.isAdmin) {
      if (participant.isModerator) {
        return makeMenuItems([
          //FocusedMenuItemData defined at the top takes a String value and a Function called action
          //removeModerator and kickOutParticipant are defined in SingleRoomController
          //Display a FocusedMenuItem with "Remove Moderator" and "Kick Out" as title and when the FocusedMenuItem is tapped the associated action is executed
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
        //if participant is neither a admin or moderator then return FocusedMenuItem with options to 
        //add a moderator, speaker or make a participant a listener or kickout a particpant
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
    //if associated controller and participant are moderator
    //then return a list of FocusedMenuItem with options to add speaker, make listener or kick participant out
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
    //get the theme of system(light or dark)
    Brightness currentBrightness = Theme.of(context).brightness;
    //build a FocusedMenuHolder defined in focused_menu package
    return FocusedMenuHolder(
      onPressed: () {},
      //customize the FocusedMenuHolder
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
      //fetch the menuItems using getMenuItems
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
              //display the role of a participant
              getUserRole(),
              style: TextStyle(color: Colors.grey, fontSize: UiSizes.size_14),
            )
          ],
        ),
      ),
    );
  }
}
