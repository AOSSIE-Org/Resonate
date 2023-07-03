import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:resonate/controllers/rooms_controller.dart';

import '../../utils/enums/room_state.dart';
import '../widgets/room_tile.dart';

class HomeScreen extends StatelessWidget {
  RoomsController roomsController = Get.find<RoomsController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RoomsController>(
        builder: (roomsController) => (!roomsController.isLoading.value)
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: Get.height * 0.015,
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: roomsController.rooms.length,
                        itemBuilder: (ctx, index) {
                          var room = roomsController.rooms[index];
                          return RoomTile(
                            roomName: room["name"],
                            roomState: RoomState.live,
                            totalActiveMembers: room["total_participants"],
                            tags: room["tags"],
                            memberAvatarUrls: [
                              "https://avatars.githubusercontent.com/u/58695010?s=96&v=4",
                              "https://avatars.githubusercontent.com/u/41890434?v=4",
                              "https://avatars.githubusercontent.com/u/43133646?s=96&v=4",
                            ],
                          );
                        }),
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(color: Colors.amber,),
              ));
  }
}
