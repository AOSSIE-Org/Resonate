import 'package:flutter/material.dart';
import 'package:resonate/features/interests/model/interest.dart';
import 'package:resonate/features/interests/view/widgets/interest_visuals.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/ui_sizes.dart';

class InterestSelector extends StatelessWidget {
  const InterestSelector({
    required this.selected,
    required this.onToggle,
    this.interests = Interest.values,
    super.key,
  });

  final Set<Interest> selected;
  final ValueChanged<Interest> onToggle;
  final List<Interest> interests;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Wrap(
      spacing: UiSizes.width_8,
      runSpacing: UiSizes.height_8,
      children: [
        for (final interest in interests)
          FilterChip(
            selected: selected.contains(interest),
            onSelected: (_) => onToggle(interest),
            showCheckmark: false,
            avatar: Icon(
              interest.icon,
              size: UiSizes.size_18,
              color: selected.contains(interest)
                  ? scheme.onPrimary
                  : scheme.onSurfaceVariant,
            ),
            label: Text(interest.label(l10n)),
            labelStyle: TextStyle(
              color: selected.contains(interest)
                  ? scheme.onPrimary
                  : scheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
            backgroundColor: scheme.secondary,
            selectedColor: scheme.primary,
            side: BorderSide(
              color: selected.contains(interest)
                  ? scheme.primary
                  : scheme.onSurface.withValues(alpha: 0.12),
            ),
          ),
      ],
    );
  }
}
