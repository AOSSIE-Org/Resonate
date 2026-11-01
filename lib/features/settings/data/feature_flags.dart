import 'package:resonate/core/providers/get_storage_provider.dart';
import 'package:resonate/features/settings/model/app_feature.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/feature_flags.g.dart';


@Riverpod(keepAlive: true)
class FeatureFlags extends _$FeatureFlags {
  @override
  Set<AppFeature> build() {
    final box = ref.watch(getStorageBoxProvider);
    return {
      for (final feature in AppFeature.values)
        if (box.read<bool>(feature.storageKey) ?? true) feature,
    };
  }

  Future<void> setEnabled(AppFeature feature, bool enabled) async {
    await ref.read(getStorageBoxProvider).write(feature.storageKey, enabled);
    final next = {...state};
    if (enabled) {
      next.add(feature);
    } else {
      next.remove(feature);
    }
    state = next;
  }
}

@Riverpod(keepAlive: true)
bool featureEnabled(Ref ref, AppFeature feature) =>
    ref.watch(featureFlagsProvider).contains(feature);
