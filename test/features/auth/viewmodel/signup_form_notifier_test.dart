import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/auth/viewmodel/signup_form_notifier.dart';

void main() {
  group('SignupForm', () {
    test('initial state has both visibility flags false', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final state = container.read(signupFormProvider);
      expect(state.passwordVisible, false);
      expect(state.confirmPasswordVisible, false);
    });

    test('togglePasswordVisible only affects passwordVisible', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(signupFormProvider.notifier).togglePasswordVisible();
      final state = container.read(signupFormProvider);
      expect(state.passwordVisible, true);
      expect(state.confirmPasswordVisible, false);
    });

    test(
      'toggleConfirmPasswordVisible only affects confirmPasswordVisible',
      () {
        final container = ProviderContainer();
        addTearDown(container.dispose);
        container
            .read(signupFormProvider.notifier)
            .toggleConfirmPasswordVisible();
        final state = container.read(signupFormProvider);
        expect(state.passwordVisible, false);
        expect(state.confirmPasswordVisible, true);
      },
    );

    test('reset clears both flags', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(signupFormProvider.notifier);
      notifier.togglePasswordVisible();
      notifier.toggleConfirmPasswordVisible();
      notifier.reset();
      final state = container.read(signupFormProvider);
      expect(state.passwordVisible, false);
      expect(state.confirmPasswordVisible, false);
    });
  });
}
