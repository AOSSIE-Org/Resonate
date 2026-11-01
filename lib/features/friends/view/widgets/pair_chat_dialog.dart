import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:language_picker/language_picker_dropdown.dart';
import 'package:language_picker/languages.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/friends/viewmodel/pair_chat_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/shared/widgets/snackbar.dart';

Future<void> showPairChatDialog(BuildContext context) {
  return showDialog(
    context: context,
    useRootNavigator: true,
    builder: (_) => const PairChatDialog(),
  );
}

class PairChatDialog extends ConsumerStatefulWidget {
  const PairChatDialog({super.key});

  @override
  ConsumerState<PairChatDialog> createState() => _PairChatDialogState();
}

class _PairChatDialogState extends ConsumerState<PairChatDialog> {
  @override
  void initState() {
    super.initState();
    // Reset any stale pairing state when the dialog opens.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.read(pairChatProvider.notifier).reset();
    });
  }

  Future<void> _startFlow(
    BuildContext context, {
    required Future<void> Function() request,
    required String destination,
  }) async {
    final router = GoRouter.of(context);
    final l10n = AppLocalizations.of(context)!;
    Navigator.of(context, rootNavigator: true).pop();
    try {
      await request();
      router.push(destination);
    } catch (e) {
      log('Pair chat request failed: $e');
      customSnackbar(l10n.error, e.toString(), LogType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAnonymous =
        ref.watch(pairChatProvider.select((s) => s.isAnonymous));
    final notifier = ref.read(pairChatProvider.notifier);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UiSizes.size_24),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 12,
      child: Padding(
        padding: EdgeInsets.all(UiSizes.size_28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title
            Text(
              AppLocalizations.of(context)!.pairChat,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: UiSizes.height_20),
            Divider(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.3),
              thickness: UiSizes.height_1,
            ),
            SizedBox(height: UiSizes.height_16), // Identity Selection Section
            Text(
              AppLocalizations.of(context)!.chooseIdentity,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: UiSizes.height_16),
            // Anonymous and Authenticated Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => notifier.setAnonymous(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isAnonymous
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                      elevation: isAnonymous ? 6 : 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(UiSizes.size_12),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: UiSizes.height_14,
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.anonymous,
                      style: TextStyle(
                        color: isAnonymous
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: UiSizes.size_12,
                        fontWeight: FontWeight.w600,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: UiSizes.width_10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => notifier.setAnonymous(false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !isAnonymous
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHigh,
                      elevation: !isAnonymous ? 6 : 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(UiSizes.size_12),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: UiSizes.height_14,
                        horizontal: UiSizes.width_5,
                      ),
                    ),
                    child: Text(
                      ref.read(requireUserProvider).displayName,
                      style: TextStyle(
                        color: !isAnonymous
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: UiSizes.size_12,
                        fontWeight: FontWeight.w600,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: UiSizes.height_24_6),
            Divider(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.3),
              thickness: UiSizes.height_1,
            ),
            SizedBox(height: UiSizes.height_16), // Language Selection Section
            Text(
              AppLocalizations.of(context)!.selectLanguage,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: UiSizes.height_16),
            LanguagePickerDropdown(
              initialValue: Language.fromIsoCode(
                Localizations.localeOf(context).languageCode,
              ),
              onValuePicked: (Language language) {
                log(language.isoCode);
                notifier.setLanguage(language.isoCode);
              },
            ),
            SizedBox(height: UiSizes.height_30),

            ElevatedButton(
              onPressed: () => _startFlow(
                context,
                request: notifier.quickMatch,
                destination: RoutePaths.pairing,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(UiSizes.size_12),
                ),
                padding: EdgeInsets.all(UiSizes.size_14),
              ),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  AppLocalizations.of(context)!.quickMatch,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: UiSizes.size_16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(UiSizes.size_8),
              child: Text(AppLocalizations.of(context)!.or),
            ),
            ElevatedButton(
              onPressed: () => _startFlow(
                context,
                request: notifier.choosePartner,
                destination: RoutePaths.pairChatUsers,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(UiSizes.size_12),
                ),
                padding: EdgeInsets.all(UiSizes.size_14),
              ),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  AppLocalizations.of(context)!.chooseUser,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: UiSizes.size_16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
