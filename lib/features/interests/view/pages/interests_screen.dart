import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/features/interests/data/my_interests.dart';
import 'package:resonate/features/interests/model/interest.dart';
import 'package:resonate/features/interests/view/widgets/interest_selector.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/shared/widgets/snackbar.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/utils/ui_sizes.dart';

class InterestsScreen extends ConsumerStatefulWidget {
  const InterestsScreen({super.key});

  @override
  ConsumerState<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends ConsumerState<InterestsScreen> {
  Set<Interest>? _selected;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    ref.listenManual(myInterestsProvider, (_, next) {
      if (next case AsyncData(:final value)) {
        if (_selected == null) setState(() => _selected = value.toSet());
      }
    }, fireImmediately: true);
  }

  void _toggle(Interest interest, AppLocalizations l10n) {
    final selected = _selected;
    if (selected == null) return;

    if (selected.contains(interest)) {
      setState(() => selected.remove(interest));
      return;
    }
    if (selected.length >= Interest.maxSelectable) {
      customSnackbar(
        l10n.interests,
        l10n.interestLimitReached(Interest.maxSelectable),
        LogType.warning,
        snackbarDuration: 1,
      );
      return;
    }
    setState(() => selected.add(interest));
  }

  Future<void> _save(AppLocalizations l10n) async {
    final selected = _selected;
    if (selected == null || _isSaving) return;

    setState(() => _isSaving = true);
    final saved = await ref
        .read(myInterestsProvider.notifier)
        .save(selected.toList());
    if (!mounted) return;
    setState(() => _isSaving = false);

    customSnackbar(
      saved ? l10n.interests : l10n.error,
      saved ? l10n.interestsUpdated : l10n.interestsUpdateFailed,
      saved ? LogType.success : LogType.error,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final stored = ref.watch(myInterestsProvider);
    final selected = _selected;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.interests),
        actions: [
          if (selected != null && selected.isNotEmpty)
            TextButton(
              onPressed: _isSaving
                  ? null
                  : () => setState(() => selected.clear()),
              child: Text(l10n.clear),
            ),
        ],
      ),
      body: stored.isLoading && selected == null
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
                      onToggle: (interest) => _toggle(interest, l10n),
                    ),
                    SizedBox(height: UiSizes.height_30),
                    SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                        onPressed: selected == null || _isSaving
                            ? null
                            : () => _save(l10n),
                        child: _isSaving
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
