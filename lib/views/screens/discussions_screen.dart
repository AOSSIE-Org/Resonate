import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/controllers/discussions_controller.dart';
import 'package:resonate/utils/app_images.dart';
import 'package:resonate/utils/colors.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/views/widgets/discussion_tile.dart';
import 'package:shimmer/shimmer.dart';

class DiscussionScreen extends StatelessWidget {
  DiscussionScreen({super.key});

  final DiscussionsController discussionsController =
      Get.find<DiscussionsController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DiscussionsController>(
        builder: (discussionsController) => (!discussionsController
                .isLoading.value)
            ? CustomRefreshIndicator(
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
                  await discussionsController.getDiscussions();
                },
                child: Visibility(
                  visible: discussionsController.discussions.isEmpty,
                  replacement: ListView.builder(
                      shrinkWrap: true,
                      itemCount: discussionsController.discussions.length,
                      itemBuilder: (ctx, index) {
                        return FutureBuilder(
                          future: discussionsController.fetchDiscussionDetails(
                              discussionsController.discussions[index].$id),
                          builder: ((context, snapshot) {
                            if (snapshot.hasData) {
                              return DiscussionTile(
                                discussion:
                                    discussionsController.discussions[index],
                                subscriberCount: snapshot.data![0].toString(),
                                userIsCreator: snapshot.data![1],
                                subscriberProfileUrl: snapshot.data![2],
                                userSubscriberId: snapshot.data![3],
                              );
                            }
                            return Shimmer.fromColors(
                                baseColor: discussionsController
                                    .getShimmerColor()['baseColor']!,
                                highlightColor: discussionsController
                                    .getShimmerColor()['highlightColor']!,
                                child: Container(
                                  height: UiSizes.height_160,
                                  margin: EdgeInsets.symmetric(
                                      vertical: UiSizes.height_10,
                                      horizontal: UiSizes.width_10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(UiSizes.size_15))),
                                ));
                          }),
                        );
                      }),
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
                          "No Discussions Available\n Get Started by adding one below!",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: UiSizes.size_19),
                        ),
                      ),
                      SizedBox(
                        height: UiSizes.height_10,
                      ),
                      OutlinedButton(
                        onPressed: () {
                          discussionsController.getDiscussions();
                        },
                        style: OutlinedButton.styleFrom(
                          maximumSize: Size.fromWidth(UiSizes.width_123_4),
                          side: const BorderSide(color: Colors.amber, width: 1),
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
              )
            : Center(
                child: LoadingAnimationWidget.threeRotatingDots(
                    color: Colors.amber, size: Get.pixelRatio * 20),
              ));
  }
}
