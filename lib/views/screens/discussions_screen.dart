// import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:resonate/controllers/upcomming_rooms_controller.dart';
// import 'package:resonate/controllers/tabview_controller.dart';
// import 'package:resonate/themes/theme_controller.dart';
// import 'package:resonate/utils/app_images.dart';
// import 'package:resonate/utils/ui_sizes.dart';
// import 'package:resonate/views/widgets/discussion_tile.dart';
// import 'package:shimmer/shimmer.dart';

// class DiscussionScreen extends StatelessWidget {
//   DiscussionScreen({super.key});
//   final TabViewController tabViewController = Get.find<TabViewController>();
//   final DiscussionsController discussionsController =
//       Get.find<DiscussionsController>();
//   final ThemeController themeController = Get.find<ThemeController>();

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         tabViewController.setIndex(0);
//         return false;
//       },
//       child: GetBuilder<DiscussionsController>(
//           builder: (discussionsController) => (!discussionsController
//                   .isLoading.value)
//               ? CustomRefreshIndicator(
//                   builder: MaterialIndicatorDelegate(
//                     builder: (context, controller) {
//                       return Icon(
//                         Icons.ac_unit,
//                         color: themeController.primaryColor.value,
//                         size: UiSizes.size_30,
//                       );
//                     },
//                   ),
//                   onRefresh: () async {
//                     await discussionsController.getUpcomingRooms();
//                   },
//                   child: Visibility(
//                     visible: discussionsController.discussions.isEmpty,
//                     replacement: Obx(
//                       () => ListView.builder(
//                           controller: discussionsController
//                               .discussionScrollController.value,
//                           shrinkWrap: true,
//                           itemCount: discussionsController.discussions.length,
//                           itemBuilder: (ctx, index) {
//                             return FutureBuilder(
//                               future: discussionsController
//                                   .fetchDiscussionDetails(discussionsController
//                                       .discussions[index].$id),
//                               builder: ((context, snapshot) {
//                                 if (snapshot.hasData) {
//                                   return DiscussionTile(
//                                     discussion: discussionsController
//                                         .discussions[index],
//                                     subscriberCount: (snapshot.data != null &&
//                                             snapshot.data!.isNotEmpty &&
//                                             snapshot.data![0] != null)
//                                         ? snapshot.data![0].toString()
//                                         : "",
//                                     userIsCreator: (snapshot.data != null &&
//                                             snapshot.data!.length > 1 &&
//                                             snapshot.data![1] != null)
//                                         ? snapshot.data![1]
//                                         : false,
//                                     subscriberProfileUrl:
//                                         (snapshot.data != null &&
//                                                 snapshot.data!.length > 2 &&
//                                                 snapshot.data![2] != null)
//                                             ? snapshot.data![2]
//                                             : "",
//                                     userSubscriberId: (snapshot.data != null &&
//                                             snapshot.data!.length > 3 &&
//                                             snapshot.data![3] != null)
//                                         ? snapshot.data![3]
//                                         : "",
//                                   );
//                                 }
//                                 return Shimmer.fromColors(
//                                     baseColor: discussionsController
//                                         .getShimmerColor()['baseColor']!,
//                                     highlightColor: discussionsController
//                                         .getShimmerColor()['highlightColor']!,
//                                     child: Container(
//                                       height: UiSizes.height_160,
//                                       margin: EdgeInsets.symmetric(
//                                           vertical: UiSizes.height_10,
//                                           horizontal: UiSizes.width_10),
//                                       decoration: BoxDecoration(
//                                           color: Colors.white,
//                                           borderRadius: BorderRadius.all(
//                                               Radius.circular(
//                                                   UiSizes.size_15))),
//                                     ));
//                               }),
//                             );
//                           }),
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         SizedBox(
//                           height: UiSizes.height_12,
//                         ),
//                         Image.asset(
//                           AppImages.noRoomImage,
//                           height: UiSizes.height_140,
//                         ),
//                         SizedBox(
//                           height: UiSizes.height_30,
//                         ),
//                         Center(
//                           child: Text(
//                             "No Discussions Available\n Get Started by adding one below!",
//                             textAlign: TextAlign.center,
//                             style: TextStyle(fontSize: UiSizes.size_19),
//                           ),
//                         ),
//                         SizedBox(
//                           height: UiSizes.height_20,
//                         ),
//                         OutlinedButton(
//                             onPressed: () {
//                               discussionsController.getUpcomingRooms();
//                             },
//                             style: OutlinedButton.styleFrom(
//                               maximumSize: Size.fromWidth(UiSizes.width_140),
//                             ),
//                             child: Center(
//                               child: Text(
//                                 "Refresh",
//                               ),
//                             ))
//                       ],
//                     ),
//                   ),
//                 )
//               : Center(
//                   child: LoadingAnimationWidget.threeRotatingDots(
//                       color: themeController.primaryColor.value,
//                       size: Get.pixelRatio * 20),
//                 )),
//     );
//   }
// }
