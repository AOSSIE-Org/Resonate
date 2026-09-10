import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/features/interests/data/interest_filter.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/ui_sizes.dart';

class InterestFilterButton extends ConsumerWidget {
  const InterestFilterButton({
    required this.onPressed,
    this.isOpen = false,
    super.key,
  });

  final VoidCallback onPressed;
  final bool isOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final filter = ref.watch(interestFilterProvider);
    final isHighlighted = isOpen || filter.isActive;

    return IconButton(
      onPressed: onPressed,
      tooltip: l10n.filterByInterest,
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.tune_rounded,
            size: UiSizes.size_20,
            color: isHighlighted ? scheme.primary : scheme.onSecondary,
          ),
          if (filter.isActive) ...[
            SizedBox(width: UiSizes.width_4),
            _SelectedCount(count: filter.selected.length),
          ],
        ],
      ),
    );
  }
}

class _SelectedCount extends StatelessWidget {
  const _SelectedCount({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: UiSizes.width_6,
        vertical: UiSizes.height_2,
      ),
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: BorderRadius.circular(UiSizes.width_10),
      ),
      child: Text(
        '$count',
        style: TextStyle(
          color: scheme.onPrimary,
          fontSize: UiSizes.size_12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
