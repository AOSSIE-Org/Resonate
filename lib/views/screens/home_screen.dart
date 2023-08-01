import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/controllers/rooms_controller.dart';

import '../widgets/room_tile.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final RoomsController roomsController = Get.find<RoomsController>();


  @override
  Widget build(BuildContext context) {
    return GetBuilder<RoomsController>(
        builder: (roomsController) => (!roomsController.isLoading.value)
            ? SingleChildScrollView(
              child: CustomRefreshIndicator(
                  builder: MaterialIndicatorDelegate(
                    builder: (context, controller) {
                      return const Icon(
                        Icons.ac_unit,
                        color: Colors.amber,
                        size: 30,
                      );
                    },
                  ),
                  onRefresh: () async {
                    await roomsController.getRooms();
                  },
                  child: Column(
                    children: [
                      SizedBox(
                        height: Get.height * 0.015,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: roomsController.rooms.length,
                          itemBuilder: (ctx, index) {
                            return RoomTile(
                              room: roomsController.rooms[index]
                            );
                          })
                    ],
                  ),
                ),
            )
            : Center(
                child: LoadingAnimationWidget.threeRotatingDots(color: Colors.amber, size: Get.pixelRatio*20),
              ));
  }
}
