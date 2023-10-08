import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:resonate/utils/ui_sizes.dart';

Widget profileAvatar(BuildContext context) {
  return GestureDetector(
    onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
    child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: UiSizes.width_10, vertical: UiSizes.height_10),
        child: GetBuilder<AuthStateController>(
          builder: (controller) => Stack(
            children: [
              SizedBox(
                width: UiSizes.width_35,
                height: UiSizes.height_45,
                child: CircularProgressIndicator(
                  color: Colors.amber,
                  strokeWidth: UiSizes.width_2,
                  value: 1,
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: Center(
                  child: CircleAvatar(
                    radius: UiSizes.size_20,
                    onBackgroundImageError: (exception, stackTrace) =>
                        const Icon(
                      Icons.person_outline,
                    ),
                    backgroundImage: controller.profileImageUrl == null ||
                            controller.profileImageUrl!.isEmpty
                        ? null
                        : NetworkImage(controller.profileImageUrl!),
                  ),
                ),
              ),
            ],
          ),
        )),
  );
}
