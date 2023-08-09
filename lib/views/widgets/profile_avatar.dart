import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/routes/app_routes.dart';

Widget profileAvatar(BuildContext context) {
  return GestureDetector(
    onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
    child: Padding(
        padding: const EdgeInsets.all(10),
        child: GetBuilder<AuthStateController>(
          builder: (controller) => Stack(
            children: [
              const SizedBox(
                width: 35,
                height: 35,
                child: CircularProgressIndicator(
                  color: Colors.amber,
                  strokeWidth: 2,
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
                    onBackgroundImageError: (exception, stackTrace) =>
                        const Icon(
                      Icons.person_outline,
                      color: Colors.amber,
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
