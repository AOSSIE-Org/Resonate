import 'package:resonate/utils/dev_log.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/shared/widgets/snackbar.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:url_launcher/url_launcher.dart';

class ContributeScreen extends StatelessWidget {
  const ContributeScreen({super.key});

  Future<void> _openUrl(BuildContext context, String url) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final launched = await launchUrl(Uri.parse(url));
      if (launched) return;
      log('URL was not launched: $url');
    } catch (e) {
      log('Error launching URL: $e');
    }
    if (!context.mounted) return;
    customSnackbar(l10n.error, l10n.tryAgain, LogType.error);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.contribute)),
      body: Container(
        padding: EdgeInsets.symmetric(
          vertical: UiSizes.height_20,
          horizontal: UiSizes.width_20,
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => _openUrl(context, githubRepoUrl),
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: UiSizes.height_20,
                  horizontal: UiSizes.width_20,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.sourceCodeOnGitHub,
                        style: TextStyle(fontSize: UiSizes.size_16),
                      ),
                    ),
                    const Icon(Icons.arrow_forward_rounded),
                  ],
                ),
              ),
            ),
            SizedBox(height: UiSizes.height_40),
            Container(
              padding: EdgeInsets.symmetric(
                vertical: UiSizes.height_20,
                horizontal: UiSizes.width_20,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocalizations.of(context)!.joinCommunity,
                      style: TextStyle(
                        fontSize: UiSizes.size_16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: UiSizes.height_20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () => _openUrl(context, xPageUrl),
                        icon: FaIcon(
                          FontAwesomeIcons.xTwitter,
                          size: UiSizes.size_40,
                        ),
                        tooltip: AppLocalizations.of(context)!.followUsOnX,
                      ),
                      IconButton(
                        onPressed: () => _openUrl(context, discordRepoUrl),
                        icon: Icon(Icons.discord, size: UiSizes.size_40),
                        tooltip: AppLocalizations.of(
                          context,
                        )!.joinDiscordServer,
                      ),
                    ],
                  ),
                  SizedBox(height: UiSizes.height_20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocalizations.of(context)!.joinCommunityDescription,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
