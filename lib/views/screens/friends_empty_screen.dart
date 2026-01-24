import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/tabview_controller.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:share_plus/share_plus.dart';

class FriendsEmptyState extends StatelessWidget {
  final bool isRequestsScreen;

  const FriendsEmptyState({super.key, required this.isRequestsScreen});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: UiSizes.width_20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isRequestsScreen
                        ? Icons.person_add_outlined
                        : Icons.people_outline_rounded,
                    size: UiSizes.size_200 * 0.6,
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.7),
                  ),
                  SizedBox(height: UiSizes.height_20),
                  Text(
                    isRequestsScreen
                        ? localizations.noFriendRequestsYet
                        : localizations.noFriendsYet,
                    style: TextStyle(
                      fontSize: UiSizes.size_24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: UiSizes.height_10),
                  Text(
                    isRequestsScreen
                        ? localizations.noFriendRequestsDescription
                        : localizations.noFriendsDescription,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: UiSizes.size_14,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: UiSizes.height_40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.find<TabViewController>().setIndex(1);
                        Get.until(
                          (route) => route.settings.name == AppRoutes.tabview,
                        );
                      },
                      icon: const Icon(Icons.search),
                      label: Text(localizations.findFriends),
                    ),
                  ),
                  SizedBox(height: UiSizes.height_14),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => SharePlus.instance.share(
                        ShareParams(
                          text: localizations.inviteToResonate(playStoreUrl),
                        ),
                      ),
                      icon: const Icon(Icons.person_add_outlined),
                      label: Text(localizations.inviteFriend),
                    ),
                  ),
                  SizedBox(height: UiSizes.height_40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
