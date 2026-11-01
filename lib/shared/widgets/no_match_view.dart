import 'package:flutter/material.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/ui_sizes.dart';

class NoMatchView extends StatelessWidget {
  const NoMatchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        AppLocalizations.of(context)!.noSearchResults,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSecondary,
          fontSize: UiSizes.size_20,
        ),
      ),
    );
  }
}
