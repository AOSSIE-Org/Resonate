import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/stories/viewmodel/chapter_player_notifier.dart';

void main() {
  setUp(TestWidgetsFlutterBinding.ensureInitialized);

  test('build returns the default player state', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final key = chapterPlayerProvider('c1');
    container.listen(key, (_, _) {});

    final state = container.read(key);

    expect(state.sliderProgress, 0.0);
    expect(state.isPlaying, isFalse);
  });

  test('onSliderChanged updates the slider progress', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final key = chapterPlayerProvider('c1');
    container.listen(key, (_, _) {});

    container.read(key.notifier).onSliderChanged(42.0);

    expect(container.read(key).sliderProgress, 42.0);
  });
}
