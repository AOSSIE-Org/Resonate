import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/controllers/rooms_controller.dart';

import '../widgets/room_tile.dart';

class HomeScreen extends StatelessWidget {
  RoomsController roomsController = Get.find<RoomsController>();

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
                      Visibility(
                        visible: roomsController.rooms.isEmpty,
                        replacement: ListView.builder(
                            shrinkWrap: true,
                            itemCount: roomsController.rooms.length,
                            itemBuilder: (ctx, index) {
                              return RoomTile(
                                room: roomsController.rooms[index],
                              );
                            }),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: Get.height * 0.15,
                              ),
                              Image.asset(
                                "assets/images/NoRoom.png",
                                height: Get.height * 0.17,
                              ),
                              SizedBox(
                                height: Get.height * 0.035,
                              ),
                              const Center(
                                child: Text(
                                  "No Rooms Available\n Get Started by adding one below!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18.0),
                                ),
                              ),
                              SizedBox(
                                height: Get.height * 0.01,
                              ),
                              OutlinedButton(
                                onPressed: () {
                                  roomsController.getRooms();
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.amber),
                                ),
                                child: const Text(
                                  "Refresh",
                                  style: TextStyle(color: Colors.amber),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Center(
                child: LoadingAnimationWidget.threeRotatingDots(
                    color: Colors.amber, size: Get.pixelRatio * 20),
              ));
  }
}
