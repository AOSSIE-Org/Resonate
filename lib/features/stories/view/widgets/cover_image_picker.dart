import 'dart:io';

import 'package:flutter/material.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/ui_sizes.dart';

class CoverImagePicker extends StatelessWidget {
  const CoverImagePicker({
    super.key,
    required this.image,
    required this.placeholderUrl,
    required this.onTap,
  });

  final File? image;
  final String placeholderUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(UiSizes.width_8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(UiSizes.width_20),
              child: SizedBox(
                height: UiSizes.height_140,
                width: UiSizes.height_140,
                child: image != null
                    ? Image.file(image!, fit: BoxFit.cover)
                    : Image.network(placeholderUrl, fit: BoxFit.cover),
              ),
            ),
          ),
        ),
        SizedBox(width: UiSizes.width_10),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(UiSizes.width_8),
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                height: UiSizes.height_140,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha: 0.5),
                  ),
                  borderRadius: BorderRadius.circular(UiSizes.width_20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.change_circle,
                      size: UiSizes.size_40,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    Text(l10n.changeCoverImage, textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
