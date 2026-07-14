import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/features/auth/viewmodel/current_user.dart';
import 'package:resonate/features/profile/viewmodel/delete_account_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/ui_sizes.dart';

class DeleteAccountPage extends ConsumerWidget {
  const DeleteAccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final username = ref.watch(currentUserProvider)?.userName ?? '';
    final isButtonActive = ref.watch(deleteAccountProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.deleteAccount)),
      body: Container(
        padding: EdgeInsets.symmetric(
          vertical: UiSizes.height_20,
          horizontal: UiSizes.width_20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: UiSizes.height_5),
              child: Text(
                l10n.deleteMyAccount,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: UiSizes.size_16,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
            Text(l10n.deleteAccountPermanent),
            SizedBox(height: UiSizes.height_40),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: UiSizes.size_16,
                ),
                children: [
                  TextSpan(text: l10n.toConfirmType),
                  TextSpan(
                    text: ' "$username" ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: l10n.inTheBoxBelow),
                ],
              ),
            ),
            SizedBox(height: UiSizes.height_10),
            TextField(
              onChanged: (value) => ref
                  .read(deleteAccountProvider.notifier)
                  .setButtonActive(value == username),
              keyboardType: TextInputType.text,
              autocorrect: false,
              cursorColor: Theme.of(context).colorScheme.error,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.error,
                    width: UiSizes.width_2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
            ),
            SizedBox(height: UiSizes.height_40),
            SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                  disabledForegroundColor: Theme.of(
                    context,
                  ).colorScheme.error.withAlpha(100),
                  disabledBackgroundColor: Theme.of(
                    context,
                  ).colorScheme.error.withAlpha(50),
                ),
                onPressed: isButtonActive
                    ? () {
                        // DO NOT IMPLEMENT THIS WITHOUT PERMISSION
                      }
                    : null,
                child: Text(
                  l10n.iUnderstandDeleteMyAccount,
                  style: TextStyle(fontSize: UiSizes.size_16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
