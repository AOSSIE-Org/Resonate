import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:resonate/core/container.dart';
import 'package:resonate/features/auth/viewmodel/auth_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/routes/app_router.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/utils/ui_sizes.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final double padding = UiSizes.width_20;

  Widget customTile({required String str, required Callback func}) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: padding),
      title: Text(str),
      trailing: const Icon(Icons.arrow_forward_rounded),
      onTap: func,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget customDivider() {
      return Divider(
        height: UiSizes.height_30,
        thickness: 10,
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.black.withValues(alpha: 0.04)
            : Colors.white.withValues(alpha: 0.04),
      );
    }

    Widget titleText(String str) {
      return Padding(
        padding: EdgeInsets.only(
          left: padding,
          top: UiSizes.height_16,
          bottom: UiSizes.height_10,
        ),
        child: Text(
          str,
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black54
                : Colors.white54,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.settings)),
      body: ListView(
        children: [
          titleText(AppLocalizations.of(context)!.accountSettings),
          customTile(
            str: AppLocalizations.of(context)!.account,
            func: () {
              appRouter.push(RoutePaths.userAccountScreen);
            },
          ),
          customDivider(),
          titleText(AppLocalizations.of(context)!.appSettings),
          customTile(
            str: AppLocalizations.of(context)!.themes,
            func: () {
              appRouter.push(RoutePaths.themeScreen);
            },
          ),
          customTile(
            str: AppLocalizations.of(context)!.about,
            func: () {
              appRouter.push(RoutePaths.aboutApp);
            },
          ),
          customTile(
            str: AppLocalizations.of(context)!.appPreferences,
            func: () {
              appRouter.push(RoutePaths.appPreferencesScreen);
            },
          ),
          customDivider(),
          titleText(AppLocalizations.of(context)!.other),
          customTile(
            str: AppLocalizations.of(context)!.contribute,
            func: () {
              appRouter.push(RoutePaths.contributeScreen);
            },
          ),
          customDivider(),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: padding),
            textColor: Colors.redAccent,
            iconColor: Colors.redAccent,
            title: Text(
              AppLocalizations.of(context)!.logOut,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(Icons.logout_rounded),
            onTap: () {
              final l10n = AppLocalizations.of(context)!;
              final scheme = Theme.of(context).colorScheme;
              showDialog<void>(
                context: context,
                useRootNavigator: true,
                builder: (dialogContext) => AlertDialog(
                  backgroundColor: scheme.surface,
                  title: Text(l10n.areYouSure),
                  content: Text(l10n.loggingOut),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      child: Text(
                        l10n.no,
                        style: TextStyle(color: scheme.primary),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: scheme.primary,
                        foregroundColor: scheme.onPrimary,
                      ),
                      onPressed: () async {
                        Navigator.of(dialogContext).pop();
                        await rootContainer
                            .read(authProvider.notifier)
                            .logout();
                        appRouter.go(RoutePaths.welcome);
                      },
                      child: Text(l10n.yes),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
