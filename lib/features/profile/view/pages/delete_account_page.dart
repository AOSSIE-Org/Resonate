import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/features/auth/viewmodel/auth_notifier.dart';
import 'package:resonate/features/profile/viewmodel/delete_account_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/ui_sizes.dart';

class DeleteAccountPage extends ConsumerWidget {
  const DeleteAccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final username = ref.watch(authProvider).value?.userOrNull?.userName ?? '';
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
                  color: Colors.redAccent,
                ),
              ),
            ),
            Text(l10n.deleteAccountPermanent),
            SizedBox(height: UiSizes.height_40),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.redAccent,
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
              cursorColor: Colors.redAccent,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.redAccent,
                    width: UiSizes.width_2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: UiSizes.height_40),
            SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  disabledForegroundColor: Colors.redAccent.withAlpha(100),
                  disabledBackgroundColor: Colors.redAccent.withAlpha(50),
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
