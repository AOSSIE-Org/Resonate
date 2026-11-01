import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/utils/ui_sizes.dart';

class UserAccountScreen extends StatelessWidget {
  const UserAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.account)),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: UiSizes.height_10),
        children: [
          ListTile(
            textColor: Theme.of(context).colorScheme.error,
            iconColor: Theme.of(context).colorScheme.error,
            title: Text(
              AppLocalizations.of(context)!.deleteAccount,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(Icons.arrow_forward_rounded),
            onTap: () {
              context.push(RoutePaths.deleteAccount);
            },
          ),
        ],
      ),
    );
  }
}
