import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:resonate/features/auth/viewmodel/current_user.dart';
import 'package:resonate/features/friends/viewmodel/pair_chat_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/features/theme/viewmodel/theme_notifier.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/utils/ui_sizes.dart';

class PairingPage extends ConsumerWidget {
  const PairingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final onPrimaryColor = theme.colorScheme.onPrimary;
    final isAnonymous =
        ref.watch(pairChatProvider.select((s) => s.isAnonymous));
    final profileImageUrl = isAnonymous
        ? ref.watch(userProfileImagePlaceholderUrlProvider)
        : ref.read(requireUserProvider).profileImageUrl ?? '';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: UiSizes.height_20),
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.findingRandomPartner,
                style: TextStyle(
                  color: primaryColor,
                  fontSize: MediaQuery.of(context).devicePixelRatio * 6.5,
                ),
              ),
              SizedBox(height: UiSizes.height_5),
              Text(
                AppLocalizations.of(context)!.hangOnGoodThingsTakeTime,
                style: TextStyle(
                  fontSize: UiSizes.size_14,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              _buildLoadingIndicator(context, primaryColor, profileImageUrl),
              const Spacer(),
              _buildFooter(context, ref, primaryColor, onPrimaryColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(
    BuildContext context,
    Color primaryColor,
    String profileImageUrl,
  ) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: UiSizes.width_20,
            vertical: UiSizes.height_20,
          ),
          child: LoadingIndicator(
            indicatorType: Indicator.ballScaleMultiple,
            colors: [
              primaryColor.withValues(alpha: 0.2),
              primaryColor,
              primaryColor.withValues(alpha: 0.6),
            ],
            strokeWidth: 2,
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: CircleAvatar(
              radius: MediaQuery.of(context).size.height * 0.05,
              backgroundImage: NetworkImage(profileImageUrl),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(
    BuildContext context,
    WidgetRef ref,
    Color primaryColor,
    Color onPrimaryColor,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: UiSizes.width_20),
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.quickFact,
            style: TextStyle(
              color: primaryColor,
              fontSize: MediaQuery.of(context).devicePixelRatio * 6.5,
            ),
          ),
          Text(
            AppLocalizations.of(context)!.resonateOpenSourceProject,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: UiSizes.size_14,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: UiSizes.height_15),
          ElevatedButton(
            onPressed: () async {
              final router = GoRouter.of(context);
              await ref.read(pairChatProvider.notifier).cancelRequest();
              router.go(RoutePaths.tabview);
            },
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: TextStyle(
                color: onPrimaryColor,
                fontSize: MediaQuery.of(context).devicePixelRatio * 8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
