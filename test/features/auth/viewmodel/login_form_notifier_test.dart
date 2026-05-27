import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/auth/viewmodel/login_form_notifier.dart';

void main() {
  group('LoginForm', () {
    test('initial state has passwordVisible=false', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      expect(container.read(loginFormProvider).passwordVisible, false);
    });

    test('togglePasswordVisible flips the bool', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(loginFormProvider.notifier);

      notifier.togglePasswordVisible();
      expect(container.read(loginFormProvider).passwordVisible, true);

      notifier.togglePasswordVisible();
      expect(container.read(loginFormProvider).passwordVisible, false);
    });

    test('reset returns state to initial', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(loginFormProvider.notifier);

      notifier.togglePasswordVisible();
      expect(container.read(loginFormProvider).passwordVisible, true);

      notifier.reset();
      expect(container.read(loginFormProvider).passwordVisible, false);
    });
  });
}
