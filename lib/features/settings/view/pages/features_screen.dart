import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/features/settings/data/feature_flags.dart';
import 'package:resonate/features/settings/model/app_feature.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/ui_sizes.dart';

class FeaturesScreen extends ConsumerWidget {
  const FeaturesScreen({super.key});

  static String titleOf(AppFeature feature, AppLocalizations l10n) =>
      switch (feature) {
        AppFeature.pairChat => l10n.pairChat,
        AppFeature.liveChapter => l10n.liveChapter,
      };

  static String descriptionOf(AppFeature feature, AppLocalizations l10n) =>
      switch (feature) {
        AppFeature.pairChat => l10n.pairChatFeatureDescription,
        AppFeature.liveChapter => l10n.liveChapterFeatureDescription,
      };

  static IconData iconOf(AppFeature feature) => switch (feature) {
    AppFeature.pairChat => Icons.people_alt_rounded,
    AppFeature.liveChapter => Icons.podcasts_rounded,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final enabled = ref.watch(featureFlagsProvider);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.features)),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: UiSizes.width_20,
              vertical: UiSizes.height_16,
            ),
            child: Text(
              l10n.featuresDescription,
              style: TextStyle(
                color: scheme.onSurface.withValues(alpha: 0.54),
                fontSize: UiSizes.size_12,
              ),
            ),
          ),
          for (final feature in AppFeature.values)
            SwitchListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: UiSizes.width_20,
              ),
              value: enabled.contains(feature),
              onChanged: (value) => ref
                  .read(featureFlagsProvider.notifier)
                  .setEnabled(feature, value),
              secondary: Icon(iconOf(feature), color: scheme.onSurfaceVariant),
              title: Text(titleOf(feature, l10n)),
              subtitle: Text(
                descriptionOf(feature, l10n),
                style: TextStyle(color: scheme.onSurfaceVariant),
              ),
            ),
        ],
      ),
    );
  }
}
