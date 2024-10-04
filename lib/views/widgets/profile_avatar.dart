import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:resonate/utils/ui_sizes.dart';

Widget profileAvatar(BuildContext context) {
  final AuthStateController authStateController =
      Get.put<AuthStateController>(AuthStateController());

  return Semantics(
      label: "User profile",
      child: GestureDetector(
        onTap: () => Get.toNamed(AppRoutes.profile),
        child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: UiSizes.width_10, vertical: UiSizes.height_10),
            child: Obx(
              () => Stack(
                children: [
                  SizedBox(
                    width: UiSizes.width_35,
                    height: UiSizes.height_45,
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
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
                        backgroundColor: Colors.white,
                        radius: UiSizes.size_20,
                        onBackgroundImageError: (exception, stackTrace) =>
                            const Icon(
                          Icons.person_outline,
                        ),
                        backgroundImage: authStateController.profileImageUrl ==
                                    null ||
                                authStateController.profileImageUrl!.isEmpty
                            ? NetworkImage(
                                'https://img.freepik.com/free-vector/user-blue-gradient_78370-4692.jpg?ga=GA1.1.338869508.1708106114&semt=sph')
                            : NetworkImage(
                                authStateController.profileImageUrl!),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ));
}
