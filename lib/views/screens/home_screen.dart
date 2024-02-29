import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/controllers/rooms_controller.dart';
import 'package:resonate/themes/theme_controller.dart';
import 'package:resonate/utils/app_images.dart';
import 'package:resonate/utils/ui_sizes.dart';
import '../widgets/room_tile.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final RoomsController roomsController = Get.find<RoomsController>();
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RoomsController>(
        builder: (roomsController) => (!roomsController.isLoading.value)
            ? CustomRefreshIndicator(
                builder: MaterialIndicatorDelegate(
                  builder: (context, controller) {
                    return Icon(
                      Icons.ac_unit,
                      color: themeController.primaryColor.value,
                      size: UiSizes.size_30,
                    );
                  },
                ),
                onRefresh: () async {
                  await roomsController.getRooms();
                },
                child: Visibility(
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
                          height: UiSizes.height_12,
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
                            style: TextStyle(fontSize: UiSizes.size_19),
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
                            maximumSize: Size.fromWidth(UiSizes.width_140),
                            side: BorderSide(
                                color: themeController.primaryColor.value,
                                width: 1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Refresh",
                                style: TextStyle(
                                    color: themeController.primaryColor.value,
                                    fontSize: UiSizes.size_15),
                              ),
                              SizedBox(
                                width: UiSizes.width_6,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            : Center(
                child: LoadingAnimationWidget.threeRotatingDots(
                    color: themeController.primaryColor.value,
                    size: Get.pixelRatio * 20),
              ));
  }
}
