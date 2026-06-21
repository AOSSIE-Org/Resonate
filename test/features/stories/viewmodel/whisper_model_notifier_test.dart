import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/stories/viewmodel/whisper_model_notifier.dart';
import 'package:whisper_flutter_new/whisper_flutter_new.dart';

import '../../../helpers/test_root_container.dart';

void main() {
  setUp(stubFlutterSecureStorageChannel);

  test('build falls back to the base model when nothing is stored', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final model = await container.read(whisperModelSettingProvider.future);

    expect(model, WhisperModel.base);
  });

  test('setModel updates the current model', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await container.read(whisperModelSettingProvider.future);

    final other = WhisperModel.values.firstWhere((m) => m != WhisperModel.base);
    await container.read(whisperModelSettingProvider.notifier).setModel(other);

    expect(container.read(whisperModelSettingProvider).value, other);
  });
}
