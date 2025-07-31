import 'package:flutter/material.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:resonate/themes/theme_controller.dart';
import 'package:resonate/utils/ui_sizes.dart';

Widget profileAvatar(BuildContext context) {
  final themeController = Get.find<ThemeController>();
  return Semantics(
      label: AppLocalizations.of(context)!.userProfile,
      child: GestureDetector(
        onTap: () => Get.toNamed(AppRoutes.profile),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: UiSizes.width_10, vertical: UiSizes.height_10),
          child: Stack(
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
                child: GetBuilder<AuthStateController>(
                  builder: (authStateController) => Center(
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
                              themeController.userProfileImagePlaceholderUrl,
                            )
                          : NetworkImage(authStateController.profileImageUrl!),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ));
}
