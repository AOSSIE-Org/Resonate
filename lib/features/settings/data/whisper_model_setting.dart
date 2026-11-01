import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:whisper_flutter_new/whisper_flutter_new.dart';

const _whisperModelStorageKey = 'whisperModel';

WhisperModel _whisperModelFor(String? name) => WhisperModel.values.firstWhere(
  (m) => m.modelName == (name ?? 'base'),
  orElse: () => WhisperModel.base,
);

final whisperModelSettingProvider =
    AsyncNotifierProvider<WhisperModelSetting, WhisperModel>(
      WhisperModelSetting.new,
    );

class WhisperModelSetting extends AsyncNotifier<WhisperModel> {
  @override
  Future<WhisperModel> build() async {
    final saved = await const FlutterSecureStorage().read(
      key: _whisperModelStorageKey,
    );
    return _whisperModelFor(saved);
  }

  Future<void> setModel(WhisperModel model) async {
    await const FlutterSecureStorage().write(
      key: _whisperModelStorageKey,
      value: model.modelName,
    );
    state = AsyncData(model);
  }
}
