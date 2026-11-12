import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/features/interests/model/interest.dart';
import 'package:resonate/features/interests/view/widgets/interest_selector.dart';
import 'package:resonate/features/interests/viewmodel/interests_editor_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/shared/widgets/snackbar.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/utils/ui_sizes.dart';

class InterestsScreen extends ConsumerWidget {
  const InterestsScreen({super.key});

  void _toggle(WidgetRef ref, Interest interest, AppLocalizations l10n) {
    final accepted = ref.read(interestsEditorProvider.notifier).toggle(interest);
    if (accepted) return;
    customSnackbar(
      l10n.interests,
      l10n.interestLimitReached(Interest.maxSelectable),
      LogType.warning,
      snackbarDuration: 1,
    );
  }

  Future<void> _save(WidgetRef ref, AppLocalizations l10n) async {
    final saved = await ref.read(interestsEditorProvider.notifier).save();
    customSnackbar(
      saved ? l10n.interests : l10n.error,
      saved ? l10n.interestsUpdated : l10n.interestsUpdateFailed,
      saved ? LogType.success : LogType.error,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final edit = ref.watch(interestsEditorProvider);
    final selected = edit.selected;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.interests),
        actions: [
          if (edit.hasSelection)
            TextButton(
              onPressed: edit.isSaving
                  ? null
                  : () => ref.read(interestsEditorProvider.notifier).clear(),
              child: Text(l10n.clear),
            ),
        ],
      ),
      body: !edit.isLoaded
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.symmetric(
                horizontal: UiSizes.width_20,
                vertical: UiSizes.height_16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.interestsHint(Interest.maxSelectable),
                      style: TextStyle(
                        color: scheme.onSurface,
                        fontSize: UiSizes.size_15,
                      ),
                    ),
                    SizedBox(height: UiSizes.height_8),
                    Text(
                      l10n.interestsOptionalHint,
                      style: TextStyle(
                        color: scheme.onSurfaceVariant,
                        fontSize: UiSizes.size_13,
                      ),
                    ),
                    SizedBox(height: UiSizes.height_20),
                    InterestSelector(
                      selected: selected ?? const <Interest>{},
                      onToggle: (interest) => _toggle(ref, interest, l10n),
                    ),
                    SizedBox(height: UiSizes.height_30),
                    SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                        onPressed: edit.canSave ? () => _save(ref, l10n) : null,
                        child: edit.isSaving
                            ? SizedBox(
                                height: UiSizes.size_18,
                                width: UiSizes.size_18,
                                child: CircularProgressIndicator(
                                  strokeWidth: UiSizes.width_2,
                                ),
                              )
                            : Text(l10n.saveChanges),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
