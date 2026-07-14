import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:resonate/core/providers/get_storage_provider.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/utils/app_images.dart';
import 'package:resonate/utils/ui_sizes.dart';

class LandingPage extends ConsumerWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(toolbarHeight: 0),
      body: OnBoardingSlider(
        leading: Container(
          padding: EdgeInsets.symmetric(horizontal: UiSizes.width_10),
          child: SvgPicture.asset(
            'assets/svg/resonate_logo_white.svg',
            height: UiSizes.height_30,
            fit: BoxFit.contain,
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
        ),
        controllerColor: Theme.of(context).colorScheme.primary,
        hasFloatingButton: true,
        headerBackgroundColor: Theme.of(context).colorScheme.surface,
        finishButtonTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontSize: UiSizes.size_18,
        ),
        skipIcon: Icon(
          Icons.arrow_forward,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        onFinish: () async {
          await ref.read(getStorageBoxProvider).write('landingScreenShown', true);
          if (context.mounted) context.go(RoutePaths.welcome);
        },
        finishButtonText: AppLocalizations.of(context)!.getStarted,
        skipTextButton: Text(AppLocalizations.of(context)!.skip),
        background: [
          _LandingImage(
            imagePath: AppImages.landingFirstImage,
            initialHeight: UiSizes.height_82,
            imageHeight: UiSizes.height_246,
            imageWidth: UiSizes.width_45,
          ),
          _LandingImage(
            imagePath: AppImages.landingSecondImage,
            initialHeight: UiSizes.height_90,
            imageHeight: UiSizes.height_246,
            imageWidth: UiSizes.width_40,
          ),
          _LandingImage(
            imagePath: AppImages.landingThirdImage,
            initialHeight: UiSizes.height_90,
            imageHeight: UiSizes.height_246,
            imageWidth: UiSizes.width_56,
          ),
        ],
        totalPage: 3,
        speed: 1,
        pageBodies: [
          _Page(
            title: AppLocalizations.of(context)!.welcomeToResonate,
            body: AppLocalizations.of(context)!.joinConversationExploreRooms,
          ),
          _Page(
            title: AppLocalizations.of(context)!.exploreDiverseConversations,
            body: AppLocalizations.of(context)!.diveIntoDiverseDiscussions,
          ),
          _Page(
            title: AppLocalizations.of(context)!.yourVoiceMatters,
            body: AppLocalizations.of(context)!.atResonateEveryVoiceValued,
          ),
        ],
      ),
    );
  }
}

class _Page extends StatelessWidget {
  const _Page({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: UiSizes.width_20),
      child: Column(
        children: [
          SizedBox(height: UiSizes.height_200 * 2),
          Text(title, style: TextStyle(fontSize: UiSizes.size_23)),
          SizedBox(height: UiSizes.height_16),
          Text(
            body,
            style: TextStyle(fontSize: UiSizes.size_15),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _LandingImage extends StatelessWidget {
  const _LandingImage({
    required this.imagePath,
    required this.initialHeight,
    required this.imageHeight,
    required this.imageWidth,
  });

  final String imagePath;
  final double initialHeight;
  final double imageHeight;
  final double imageWidth;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: initialHeight),
        Row(
          children: [
            SizedBox(width: imageWidth),
            Image.asset(imagePath, height: imageHeight),
          ],
        ),
      ],
    );
  }
}
