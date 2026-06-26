import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:resonate/features/settings/viewmodel/about_app_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/routes/app_router.dart';
import 'package:resonate/shared/widgets/snackbar.dart';
import 'package:resonate/utils/app_images.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/utils/enums/update_enums.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:share_plus/share_plus.dart';

class AboutAppScreen extends ConsumerWidget {
  const AboutAppScreen({super.key});

  void _shareApp(BuildContext context) {
    SharePlus.instance.share(
      ShareParams(
        text: AppLocalizations.of(context)!.checkOutGitHub(githubRepoUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aboutApp = ref.watch(aboutAppProvider);
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
                                Text(
                                  "${aboutApp.appVersion} | ${aboutApp.appBuildNumber} | Stable",
                                  style: TextStyle(fontSize: UiSizes.size_12),
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
                  onTap: () => _handleUpdateCheck(context, ref),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      aboutApp.isCheckingForUpdate
                          ? SizedBox(
                              width: UiSizes.width_25,
                              height: UiSizes.height_26,
                              child: LoadingIndicator(
                                indicatorType: Indicator.ballPulse,
                                colors: [
                                  Theme.of(context).colorScheme.primary,
                                ],
                                strokeWidth: UiSizes.width_2,
                              ),
                            )
                          : Icon(
                              aboutApp.updateAvailable
                                  ? Icons.system_update
                                  : Icons.update,
                              size: UiSizes.size_24,
                            ),
                      SizedBox(width: UiSizes.width_10),
                      Text(
                        aboutApp.updateAvailable
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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: UiSizes.size_16,
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

  Future<void> _handleUpdateCheck(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await ref.read(aboutAppProvider.notifier).checkForUpdate(
      onIgnore: () {
        rootNavigatorKey.currentState?.pop();
        return true;
      },
      onLater: () {
        rootNavigatorKey.currentState?.pop();
        return true;
      },
      isManualCheck: true,
    );
    switch (result) {
      case UpdateCheckResult.noUpdateAvailable:
        customSnackbar(
          l10n.upToDateTitle,
          l10n.upToDateMessage,
          LogType.success,
        );
        break;
      case UpdateCheckResult.updateAvailable:
        break;
      case UpdateCheckResult.platformNotSupported:
        customSnackbar(
          l10n.platformNotSupported,
          l10n.platformNotSupportedMessage,
          LogType.warning,
        );
        break;
      case UpdateCheckResult.checkFailed:
        customSnackbar(
          l10n.updateCheckFailed,
          l10n.updateCheckFailedMessage,
          LogType.error,
        );
        break;
    }
  }
}
