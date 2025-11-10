import 'package:flutter/material.dart';
import 'package:resonate/l10n/app_localizations.dart';
// import 'package:resonate/l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:resonate/controllers/about_app_screen_controller.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/utils/enums/update_enums.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/views/widgets/snackbar.dart';
import 'package:share_plus/share_plus.dart';

import '../../utils/app_images.dart';

class AboutAppScreen extends StatelessWidget {
  AboutAppScreen({super.key});

  final aboutAppScreenController = Get.find<AboutAppScreenController>();

  void _shareApp(BuildContext context) {
    SharePlus.instance.share(
      ShareParams(
        text: AppLocalizations.of(context)!.checkOutGitHub(githubRepoUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.about)),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: UiSizes.width_20,
          vertical: UiSizes.height_20,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: UiSizes.height_200,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: UiSizes.width_20),
                    child: Column(
                      children: [
                        SizedBox(height: UiSizes.height_10),
                        Semantics(
                          label: AppLocalizations.of(context)!.resonateLogo,
                          child: Container(
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                image: AssetImage(AppImages.resonateLogoImage),
                                fit: BoxFit.cover,
                              ),
                              // color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            height: UiSizes.height_131,
                          ),
                        ),
                        Expanded(
                          child: MergeSemantics(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.title,
                                  style: TextStyle(fontSize: UiSizes.size_20),
                                ),
                                Obx(
                                  () => Text(
                                    "${aboutAppScreenController.appVersion} | ${aboutAppScreenController.appBuildNumber} | Stable",
                                    // "0.0.0 | 1 | Stable",
                                    style: TextStyle(fontSize: UiSizes.size_12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: UiSizes.width_10),
                Expanded(
                  child: Container(
                    height: UiSizes.height_200,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: UiSizes.width_20),
                    child: Column(
                      children: [
                        SizedBox(height: UiSizes.height_10),
                        Semantics(
                          label: AppLocalizations.of(context)!.aossieLogo,
                          child: Container(
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                image: AssetImage(AppImages.aossieLogoImage),
                                scale: 4,
                              ),
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            height: UiSizes.height_131,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                semanticsLabel: AppLocalizations.of(
                                  context,
                                )!.aossie,
                                AppLocalizations.of(
                                  context,
                                )!.aossie.toUpperCase(),
                                style: TextStyle(fontSize: UiSizes.size_20),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: UiSizes.height_10),
            Container(
              height: UiSizes.height_110,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(horizontal: UiSizes.width_20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocalizations.of(context)!.helpToGrow,
                      style: TextStyle(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () => _shareApp(context),
                        child: Column(
                          children: [
                            const Icon(Icons.share_rounded),
                            Text(AppLocalizations.of(context)!.share),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: [
                            const Icon(Icons.star_rate_outlined),
                            Text(AppLocalizations.of(context)!.rate),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: UiSizes.height_10),
            Container(
              height: UiSizes.height_80,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(horizontal: UiSizes.width_20),
              child: Center(
                child: GestureDetector(
                  onTap: () => _handleUpdateCheck(),
                  child: Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        aboutAppScreenController.isCheckingForUpdate.value
                            ? SizedBox(
                                width: UiSizes.width_25,
                                height: UiSizes.height_26,
                                child: LoadingIndicator(
                                  indicatorType: Indicator.ballPulse,
                                  colors: [
                                    Theme.of(context).colorScheme.primary,
                                  ],
                                  strokeWidth: 2,
                                ),
                              )
                            : Icon(
                                aboutAppScreenController.updateAvailable.value
                                    ? Icons.system_update
                                    : Icons.update,
                                size: UiSizes.size_24,
                              ),
                        SizedBox(width: UiSizes.width_10),
                        Text(
                          aboutAppScreenController.updateAvailable.value
                              ? AppLocalizations.of(context)!.updateAvailable
                              : AppLocalizations.of(context)!.checkForUpdates,
                          style: TextStyle(
                            fontSize: UiSizes.size_16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: UiSizes.height_40),
            Align(
              alignment: Alignment.centerLeft,
              child: MergeSemantics(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      semanticsLabel: AppLocalizations.of(
                        context,
                      )!.aboutResonate,
                      AppLocalizations.of(context)!.description,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: UiSizes.height_5),
                    Text(
                      AppLocalizations.of(context)!.resonateDescription,
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleUpdateCheck() async {
    final result = await aboutAppScreenController.checkForUpdate(
      onIgnore: () {
        Get.back();
        return true;
      },
      onLater: () {
        Get.back();
        return true;
      },
      isManualCheck: true,
    );
    switch (result) {
      case UpdateCheckResult.noUpdateAvailable:
        customSnackbar(
          AppLocalizations.of(Get.context!)!.upToDateTitle,
          AppLocalizations.of(Get.context!)!.upToDateMessage,
          LogType.success,
        );
        break;
      case UpdateCheckResult.updateAvailable:
        break;
      case UpdateCheckResult.platformNotSupported:
        customSnackbar(
          AppLocalizations.of(Get.context!)!.platformNotSupported,
          AppLocalizations.of(Get.context!)!.platformNotSupportedMessage,
          LogType.warning,
        );
        break;
      case UpdateCheckResult.checkFailed:
        customSnackbar(
          AppLocalizations.of(Get.context!)!.updateCheckFailed,
          AppLocalizations.of(Get.context!)!.updateCheckFailedMessage,
          LogType.error,
        );
        break;
    }
  }
}
