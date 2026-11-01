import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/auth/model/password_strength.dart';
import 'package:resonate/features/auth/viewmodel/signup_form_notifier.dart';

void main() {
  // Password strength is folded into SignupForm (it was a standalone provider
  // so the signup view had to watch two view models — the mentor's
  // one-view-one-view-model rule). These exercise it through SignupForm now.
  group('SignupForm password strength', () {
    test('initial state is empty', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      expect(container.read(signupFormProvider).strength.score, 0);
    });

    test('checkPassword("") returns empty strength', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(signupFormProvider.notifier).checkPassword('');
      expect(container.read(signupFormProvider).strength.score, 0);
    });

    test('checkPassword("Abcd1234!") scores 5 (all criteria met)', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(signupFormProvider.notifier).checkPassword('Abcd1234!');
      final s = container.read(signupFormProvider).strength;
      expect(s.hasMinLength, true);
      expect(s.hasUppercase, true);
      expect(s.hasLowercase, true);
      expect(s.hasDigit, true);
      expect(s.hasSymbol, true);
      expect(s.score, 5);
    });

    test('reset returns strength to empty', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final n = container.read(signupFormProvider.notifier);
      n.checkPassword('Abcd1234!');
      expect(container.read(signupFormProvider).strength.score, 5);
      n.reset();
      expect(container.read(signupFormProvider).strength.score, 0);
    });
  });

  group('PasswordStrength.evaluate (pure)', () {
    test('empty returns empty', () {
      expect(PasswordStrength.evaluate('').score, 0);
    });

    test('only-uppercase scores 1', () {
      expect(PasswordStrength.evaluate('ABC').score, 1);
    });

    test('short password with all character classes scores 4 (no length)', () {
      // "Ab1!" — has upper, lower, digit, symbol — but 4 chars < 8
      final s = PasswordStrength.evaluate('Ab1!');
      expect(s.hasMinLength, false);
      expect(s.hasUppercase, true);
      expect(s.hasLowercase, true);
      expect(s.hasDigit, true);
      expect(s.hasSymbol, true);
      expect(s.score, 4);
    });

    test('meetsFormRequirements needs upper+lower+digit (length>=6 handled '
        'by validator regex)', () {
      // Aa1 satisfies upper+lower+digit
      expect(PasswordStrength.evaluate('Aa1').meetsFormRequirements, true);
      // No digit
      expect(PasswordStrength.evaluate('Abcdef').meetsFormRequirements, false);
      // No uppercase
      expect(PasswordStrength.evaluate('abc123').meetsFormRequirements, false);
    });
  });
}
