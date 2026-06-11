import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:resonate/features/auth/viewmodel/auth_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/themes/theme_controller.dart';
import 'package:resonate/utils/ui_sizes.dart';

Widget profileAvatar(BuildContext context) {
  final themeController = Get.find<ThemeController>();
  return Semantics(
    label: AppLocalizations.of(context)!.userProfile,
    child: GestureDetector(
      onTap: () => context.push(RoutePaths.profile),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: UiSizes.width_10,
          vertical: UiSizes.height_10,
        ),
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
              child: Consumer(
                builder: (context, ref, _) {
                  final user = ref.watch(authProvider).value?.userOrNull;
                  final url = user?.profileImageUrl;
                  return Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: UiSizes.size_20,
                      onBackgroundImageError: (exception, stackTrace) =>
                          const Icon(Icons.person_outline),
                      backgroundImage: (url == null || url.isEmpty)
                          ? NetworkImage(
                              themeController.userProfileImagePlaceholderUrl,
                            )
                          : NetworkImage(url),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
