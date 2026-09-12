import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/features/interests/data/interest_filter.dart';
import 'package:resonate/features/interests/view/widgets/interest_profile_tile.dart';
import 'package:resonate/features/interests/view/widgets/interest_selector.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/ui_sizes.dart';


class InterestFilterPanel extends ConsumerWidget {
  const InterestFilterPanel({required this.onDone, super.key});

  final VoidCallback onDone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final filter = ref.watch(interestFilterProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.filterByInterest,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w900,
                  fontSize: UiSizes.size_20,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            if (filter.isActive)
              TextButton(
                onPressed: () =>
                    ref.read(interestFilterProvider.notifier).clear(),
                child: Text(l10n.clear),
              ),
          ],
        ),
        SizedBox(height: UiSizes.height_4),
        Text(
          l10n.interestFilterHint,
          style: TextStyle(
            color: scheme.onSurfaceVariant,
            fontSize: UiSizes.size_13,
          ),
        ),
        SizedBox(height: UiSizes.height_16),
        InterestSelector(
          selected: filter.selected,
          onToggle: (interest) =>
              ref.read(interestFilterProvider.notifier).toggle(interest),
        ),
        SizedBox(height: UiSizes.height_20),
        SizedBox(
          width: double.maxFinite,
          child: ElevatedButton(onPressed: onDone, child: Text(l10n.done)),
        ),
      ],
    );
  }
}

class InterestFilterResults extends ConsumerWidget {
  const InterestFilterResults({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final filter = ref.watch(interestFilterProvider);
    if (!filter.isActive) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.profiles,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: scheme.onSurface,
            fontWeight: FontWeight.w900,
            fontSize: UiSizes.size_20,
            fontFamily: 'Inter',
          ),
        ),
        SizedBox(height: UiSizes.height_10),
        filter.matches.when(
          loading: () => Padding(
            padding: EdgeInsets.symmetric(vertical: UiSizes.height_20),
            child: const Center(child: CircularProgressIndicator()),
          ),
          error: (_, _) => _message(context, l10n.interestFilterFailed),
          data: (users) => users.isEmpty
              ? _message(context, l10n.noProfilesForInterests)
              : ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: users.length,
                  itemBuilder: (context, index) => InterestProfileTile(
                    user: users[index],
                    highlight: filter.selected,
                  ),
                ),
        ),
      ],
    );
  }

  Widget _message(BuildContext context, String text) => Padding(
    padding: EdgeInsets.symmetric(vertical: UiSizes.height_20),
    child: Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSecondary,
          fontSize: UiSizes.size_16,
        ),
      ),
    ),
  );
}
