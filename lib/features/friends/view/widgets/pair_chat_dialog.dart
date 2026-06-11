import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:language_picker/language_picker_dropdown.dart';
import 'package:language_picker/languages.dart';
import 'package:resonate/core/container.dart';
import 'package:resonate/features/friends/viewmodel/pair_chat_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/views/widgets/snackbar.dart';

Future<void> showPairChatDialog(BuildContext context) {
  return showDialog(
    context: context,
    useRootNavigator: true,
    builder: (_) => const PairChatDialog(),
  );
}

class PairChatDialog extends ConsumerWidget {
  const PairChatDialog({super.key});

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
  Widget build(BuildContext context, WidgetRef ref) {
    final isAnonymous =
        ref.watch(pairChatProvider.select((s) => s.isAnonymous));
    final notifier = ref.read(pairChatProvider.notifier);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 12,
      child: Padding(
        padding: const EdgeInsets.all(28),
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
            const SizedBox(height: 20),

            // Divider with slight padding
            Divider(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.3),
              thickness: 1,
            ),
            const SizedBox(height: 16), // Identity Selection Section
            Text(
              AppLocalizations.of(context)!.chooseIdentity,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),

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
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
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
                const SizedBox(width: 10),
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
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 5,
                      ),
                    ),
                    child: Text(
                      requireCurrentAuthUser.displayName,
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
            const SizedBox(height: 24),

            // Divider with slight padding
            Divider(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.3),
              thickness: 1,
            ),
            const SizedBox(height: 16), // Language Selection Section
            Text(
              AppLocalizations.of(context)!.selectLanguage,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            LanguagePickerDropdown(
              initialValue: Language.fromIsoCode(
                Localizations.localeOf(context).languageCode,
              ),
              onValuePicked: (Language language) {
                log(language.isoCode);
                notifier.setLanguage(language.isoCode);
              },
            ),
            const SizedBox(height: 28),

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
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(14),
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
              padding: const EdgeInsets.all(8.0),
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
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(14),
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
