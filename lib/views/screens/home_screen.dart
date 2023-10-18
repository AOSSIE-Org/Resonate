import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/controllers/rooms_controller.dart';
import 'package:resonate/utils/app_images.dart';
import 'package:resonate/utils/ui_sizes.dart';

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
                      return Icon(
                        Icons.ac_unit,
                        color: Colors.amber,
                        size: UiSizes.size_30,
                      );
                    },
                  ),
                  onRefresh: () async {
                    await roomsController.getRooms();
                  },
                  child: Column(
                    children: [
                      SizedBox(
                        height: UiSizes.height_12,
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
                                height: UiSizes.height_140,
                              ),
                              Image.asset(
                                AppImages.noRoomImage,
                                height: UiSizes.height_140,
                              ),
                              SizedBox(
                                height: UiSizes.height_30,
                              ),
                              Center(
                                child: Text(
                                  "No Rooms Available\n Get Started by adding one below!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: UiSizes.size_19),
                                ),
                              ),
                              SizedBox(
                                height: UiSizes.height_10,
                              ),
                              OutlinedButton(
                                onPressed: () {
                                  roomsController.getRooms();
                                },
                                style: OutlinedButton.styleFrom(
                                  maximumSize:
                                      Size.fromWidth(UiSizes.width_123_4),
                                  side: const BorderSide(
                                      color: Colors.amber, width: 1),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Refresh",
                                      style: TextStyle(color: Colors.amber),
                                    ),
                                    SizedBox(
                                      width: UiSizes.width_6,
                                    ),
                                    const Icon(
                                      Icons.refresh,
                                      color: Colors.amber,
                                    ),
                                  ],
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
