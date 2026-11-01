import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/profile/viewmodel/delete_account_notifier.dart';

void main() {
  group('DeleteAccount', () {
    test('initial state is false (button disabled)', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      expect(container.read(deleteAccountProvider), false);
    });

    test('setButtonActive toggles the enabled state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(deleteAccountProvider.notifier);

      notifier.setButtonActive(true);
      expect(container.read(deleteAccountProvider), true);

      notifier.setButtonActive(false);
      expect(container.read(deleteAccountProvider), false);
    });
  });
}
