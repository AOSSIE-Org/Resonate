import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/live_chapter_controller.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:resonate/utils/ui_sizes.dart';

class FocusedMenuItemData {
  final String textContent;
  final Function action;

  FocusedMenuItemData(this.textContent, this.action);
}

class LiveChapterAttendeeBlock extends StatelessWidget {
  LiveChapterAttendeeBlock({super.key, required this.user});

  final Map<String, dynamic> user;
  final LiveChapterController controller = Get.find<LiveChapterController>();
  String getUserRole(BuildContext context) {
    if (controller.checkUserIsAdmin(user['\$id'])) {
      return AppLocalizations.of(context)!.author;
    } else {
      return AppLocalizations.of(context)!.listener;
    }
  }

  List<FocusedMenuItem> makeMenuItems(
    List<FocusedMenuItemData> items,
    Brightness currentBrightness,
  ) {
    return items
        .map(
          (item) => FocusedMenuItem(
            title: Text(
              item.textContent,
              style: TextStyle(fontSize: UiSizes.size_14),
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

  List<FocusedMenuItem> getMenuItems(
    Brightness currentBrightness,
    BuildContext context,
  ) {
    if (!controller.isAdmin) {
      return [];
    }

    //Host Controls not required as Listeners have no additional permissions
    // if (controller.isAdmin) {
    //   return makeMenuItems([
    //     FocusedMenuItemData(AppLocalizations.of(context)!.kickOut, () {
    //       // controller.kickOutParticipant(participant);
    //     }),
    //     FocusedMenuItemData(
    //       AppLocalizations.of(context)!.reportParticipant,
    //       () {
    //         // controller.reportParticipant(participant);
    //       },
    //     ),
    //   ], currentBrightness);
    // }

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
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: UiSizes.width_1,
        ),
      ),
      duration: const Duration(milliseconds: 100),
      animateMenuItems: true,
      blurBackgroundColor: currentBrightness == Brightness.light
          ? Colors.white54
          : Colors.black54,
      menuItems: getMenuItems(currentBrightness, context),
      openWithTap: controller.isAdmin ? true : false,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: UiSizes.height_2,
          horizontal: UiSizes.width_2,
        ),
        alignment: Alignment.center,
        child: Column(
          children: [
            CircleAvatar(
              radius: UiSizes.size_32,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: CircleAvatar(
                backgroundImage: NetworkImage(user['profileImageUrl'] ?? ''),
                radius: UiSizes.size_30,
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    user["name"].split(' ').first,
                    style: TextStyle(fontSize: UiSizes.size_16),
                  ),
                ],
              ),
            ),
            Text(
              getUserRole(context),
              style: TextStyle(color: Colors.grey, fontSize: UiSizes.size_14),
            ),
          ],
        ),
      ),
    );
  }
}
