import 'package:flutter/material.dart';
import 'package:resonate/utils/ui_sizes.dart';

class SessionHeader extends StatelessWidget {
  const SessionHeader({
    super.key,
    required this.title,
    required this.description,
    this.tags = const [],
  });
  final String title;
  final String description;

  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    final mutedColor = Theme.of(context).colorScheme.onSurfaceVariant;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: UiSizes.size_32,
            fontWeight: FontWeight.bold,
            height: 1.1,
          ),
        ),
        if (description.isNotEmpty) ...[
          SizedBox(height: UiSizes.height_7),
          Text(
            description,
            style: TextStyle(color: mutedColor, fontSize: UiSizes.size_14),
          ),
        ],
        if (tags.isNotEmpty) ...[
          SizedBox(height: UiSizes.height_8),
          Wrap(
            spacing: UiSizes.width_6,
            runSpacing: UiSizes.height_5,
            children: [for (final tag in tags) _TagChip(label: tag)],
          ),
        ],
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: UiSizes.width_8,
        vertical: UiSizes.height_4,
      ),
      decoration: BoxDecoration(
        color: scheme.secondary,
        borderRadius: BorderRadius.circular(UiSizes.width_6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: scheme.onSurfaceVariant,
          fontSize: UiSizes.size_15,
        ),
      ),
    );
  }
}
