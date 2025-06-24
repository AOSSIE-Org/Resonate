import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/controllers/pair_chat_controller.dart';
import 'package:resonate/themes/theme_controller.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PairingScreen extends StatelessWidget {
  final PairChatController controller = Get.find<PairChatController>();
  final ThemeController themeController = Get.find<ThemeController>();

  PairingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final onPrimaryColor = theme.colorScheme.onPrimary;
    final profileImageUrl = controller.isAnonymous.value
        ? themeController.userProfileImagePlaceholderUrl
        : Get.find<AuthStateController>().profileImageUrl!;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: UiSizes.height_20),
          child: Column(
            children: [
              _buildTitle(primaryColor, context),
              SizedBox(height: UiSizes.height_5),
              _buildSubtitle(context),
              const Spacer(),
              _buildLoadingIndicator(context, primaryColor, profileImageUrl),
              const Spacer(),
              _buildFooter(primaryColor, onPrimaryColor, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(Color primaryColor, BuildContext context) {    return Text(
      AppLocalizations.of(context)!.findingRandomPartner,
      style: TextStyle(
        color: primaryColor,
        fontSize: Get.pixelRatio * 6.5,
      ),
    );
  }
  Widget _buildSubtitle(BuildContext context) {
    return Text(
      AppLocalizations.of(context)!.hangOnGoodThingsTakeTime,
      style: TextStyle(
        fontSize: UiSizes.size_14,
        color: Colors.grey.shade500,
      ),
    );
  }

  Widget _buildLoadingIndicator(
      BuildContext context, Color primaryColor, String profileImageUrl) {
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
              radius: Get.size.height * 0.05,
              backgroundImage: NetworkImage(profileImageUrl),
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildFooter(Color primaryColor, Color onPrimaryColor, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: UiSizes.width_20),
      child: Column(
        children: [
          _buildQuickFact(primaryColor, context),
          SizedBox(height: UiSizes.height_15),
          _buildCancelButton(primaryColor, onPrimaryColor, context),
        ],
      ),
    );
  }
  Widget _buildQuickFact(Color primaryColor, BuildContext context) {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context)!.quickFact,
          style: TextStyle(
            color: primaryColor,
            fontSize: Get.pixelRatio * 6.5,
          ),
        ),        Text(
          AppLocalizations.of(context)!.resonateOpenSourceProject,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: UiSizes.size_14,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }

  Widget _buildCancelButton(Color primaryColor, Color onPrimaryColor, BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await controller.cancelRequest();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
      ),      child: Text(
        AppLocalizations.of(context)!.cancel,
        style: TextStyle(
          color: onPrimaryColor,
          fontSize: Get.pixelRatio * 8,
        ),
      ),
    );
  }
}
