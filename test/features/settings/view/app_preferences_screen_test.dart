import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:language_picker/language_picker_dropdown.dart';
import 'package:resonate/features/settings/view/pages/app_preferences_screen.dart';
import 'package:resonate/features/settings/viewmodel/locale_notifier.dart';
import 'package:resonate/features/stories/data/whisper_model_setting.dart';
import 'package:whisper_flutter_new/whisper_flutter_new.dart';

import '../settings_test_helpers.dart';

class FakeWhisperModelSetting extends WhisperModelSetting {
  FakeWhisperModelSetting(this.preset);

  final WhisperModel preset;
  final List<WhisperModel> setCalls = [];

  @override
  Future<WhisperModel> build() async => preset;

  @override
  Future<void> setModel(WhisperModel model) async {
    setCalls.add(model);
    state = AsyncData(model);
  }
}

void main() {
  List<Override> buildOverrides({
    required FakeWhisperModelSetting whisperFake,
  }) {
    return [
      whisperModelSettingProvider.overrideWith(() => whisperFake),
      appLocaleProvider.overrideWith(AppLocale.new),
    ];
  }

  testWidgets('renders the Select Language section with a seeded dropdown', (
    tester,
  ) async {
    final whisperFake = FakeWhisperModelSetting(WhisperModel.base);
    await pumpSettingsPage(tester, const AppPreferencesScreen(),
        overrides: buildOverrides(whisperFake: whisperFake));
    await tester.pumpAndSettle();

    expect(find.text('Select Language'), findsOneWidget);
    // The third-party dropdown renders and is seeded to the current locale (en).
    expect(find.byType(LanguagePickerDropdown), findsOneWidget);
    final dropdown = tester.widget<LanguagePickerDropdown>(
      find.byType(LanguagePickerDropdown),
    );
    expect(dropdown.initialValue?.isoCode, 'en');
  });

  testWidgets('the current model tile shows check_circle, others outlined', (
    tester,
  ) async {
    final whisperFake = FakeWhisperModelSetting(WhisperModel.small);
    await pumpSettingsPage(tester, const AppPreferencesScreen(),
        overrides: buildOverrides(whisperFake: whisperFake));
    await tester.pumpAndSettle();

    // Exactly one selected tile; remaining five show the outlined circle.
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    expect(find.byIcon(Icons.circle_outlined), findsNWidgets(5));

    // The selected marker sits on the Small tile.
    final selectedTile = find.ancestor(
      of: find.text('Small'),
      matching: find.byType(ListTile),
    );
    expect(
      find.descendant(
        of: selectedTile,
        matching: find.byIcon(Icons.check_circle),
      ),
      findsOneWidget,
    );
  });

  testWidgets('tapping a non-selected model tile calls setModel', (
    tester,
  ) async {
    final whisperFake = FakeWhisperModelSetting(WhisperModel.base);
    await pumpSettingsPage(tester, const AppPreferencesScreen(),
        overrides: buildOverrides(whisperFake: whisperFake));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Medium'));
    await tester.pumpAndSettle();

    expect(whisperFake.setCalls, [WhisperModel.medium]);
  });
}
