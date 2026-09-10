import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/features/achievements/view/widgets/achievements_sheet.dart';
import 'package:resonate/features/activity_status/data/my_activity_status.dart';
import 'package:resonate/features/activity_status/view/widgets/activity_dot.dart';
import 'package:resonate/features/activity_status/view/widgets/activity_status_sheet.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/settings/viewmodel/settings_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/routes/app_router.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/utils/ui_sizes.dart';

class SettingsScreen extends ConsumerWidget {
  SettingsScreen({super.key});

  final double padding = UiSizes.width_20;

  Widget customTile({required String str, required VoidCallback func}) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: padding),
      title: Text(str),
      trailing: const Icon(Icons.arrow_forward_rounded),
      onTap: func,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget customDivider() {
      return Divider(
        height: UiSizes.height_30,
        thickness: 5,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.04),
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
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.54),
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
              ref.read(routerProvider).push(RoutePaths.userAccountScreen);
            },
          ),
          Builder(
            builder: (context) {
              final status = ref.watch(myActivityStatusProvider);
              return ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: padding),
                title: Text(AppLocalizations.of(context)!.activityStatus),
                subtitle: Text(
                  status.label(AppLocalizations.of(context)!),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                trailing: ActivityDot(status: status, size: UiSizes.size_14),
                onTap: () => showActivityStatusSheet(context),
              );
            },
          ),
          Builder(
            builder: (context) {
              final uid = ref.watch(currentUserProvider)?.uid;
              if (uid == null) return const SizedBox.shrink();
              return customTile(
                str: AppLocalizations.of(context)!.achievements,
                func: () => showAchievementsSheet(
                  context,
                  uid: uid,
                  isOwnProfile: true,
                ),
              );
            },
          ),
          customTile(
            str: AppLocalizations.of(context)!.interests,
            func: () {
              ref.read(routerProvider).push(RoutePaths.interestsScreen);
            },
          ),
          customDivider(),
          titleText(AppLocalizations.of(context)!.appSettings),
          customTile(
            str: AppLocalizations.of(context)!.themes,
            func: () {
              ref.read(routerProvider).push(RoutePaths.themeScreen);
            },
          ),
          customTile(
            str: AppLocalizations.of(context)!.about,
            func: () {
              ref.read(routerProvider).push(RoutePaths.aboutApp);
            },
          ),
          customTile(
            str: AppLocalizations.of(context)!.appPreferences,
            func: () {
              ref.read(routerProvider).push(RoutePaths.appPreferencesScreen);
            },
          ),
          customTile(
            str: AppLocalizations.of(context)!.features,
            func: () {
              ref.read(routerProvider).push(RoutePaths.featuresScreen);
            },
          ),
          customDivider(),
          titleText(AppLocalizations.of(context)!.other),
          customTile(
            str: AppLocalizations.of(context)!.contribute,
            func: () {
              ref.read(routerProvider).push(RoutePaths.contributeScreen);
            },
          ),
          customDivider(),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: padding),
            textColor: Theme.of(context).colorScheme.error,
            iconColor: Theme.of(context).colorScheme.error,
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
                        await ref.read(settingsProvider.notifier).logout();
                        ref.read(routerProvider).go(RoutePaths.welcome);
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
