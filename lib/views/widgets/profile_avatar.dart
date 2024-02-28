//import required packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:resonate/utils/ui_sizes.dart';

//profileAvatar is a clickable widget which navigates the user to profile route.
Widget profileAvatar(BuildContext context) {
  return GestureDetector(
    onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
    //contents of profile Avatar
    child: Padding(
      padding: EdgeInsets.symmetric(
          horizontal: UiSizes.width_10, vertical: UiSizes.height_10),
      //Using GetBuilder to track changes made by AuthStateController
      //NOTE: since we are only concerned by changes of a single controller
      //using GetBuilder than GetX or ObX is more economical.
      child: GetBuilder<AuthStateController>(
        builder: (controller) => Stack(
          children: [
            //Display a CircularProgressIndicator
            //Since the value is 1(constant) the CircularProgressIndicator will not show any changes
            SizedBox(
              width: UiSizes.width_35,
              height: UiSizes.height_45,
              child: CircularProgressIndicator(
                color: Colors.amber,
                strokeWidth: UiSizes.width_2,
                value: 1,
              ),
            ),
            //Use Positioned widget to position the child widget inside a Stack
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Center(
                //Use CircleAvatar to display a image
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: UiSizes.size_20,
                  //if there are any errors or the image is still loading then display a person_outline icon.
                  onBackgroundImageError: (exception, stackTrace) => const Icon(
                    Icons.person_outline,
                  ),
                  //use trenery operator to load image based on the specified condition
                  //Condition: if the condition (profileImageUrl is null or empty) is true then backgroundImage is not shown
                  //if the condition is false then image is loaded from profileImageUrl with the help of NetworkImage widget.
                  backgroundImage: controller.profileImageUrl == null ||
                          controller.profileImageUrl!.isEmpty
                      ? null
                      : NetworkImage(controller.profileImageUrl!),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
