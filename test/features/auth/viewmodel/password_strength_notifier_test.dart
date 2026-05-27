import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/auth/model/password_strength.dart';
import 'package:resonate/features/auth/viewmodel/password_strength_notifier.dart';

void main() {
  group('PasswordStrengthChecker (notifier)', () {
    test('initial state is empty', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      expect(container.read(passwordStrengthCheckerProvider).score, 0);
    });

    test('check("") returns empty strength', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(passwordStrengthCheckerProvider.notifier).check('');
      expect(container.read(passwordStrengthCheckerProvider).score, 0);
    });

    test('check("Abcd1234!") scores 5 (all criteria met)', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container
          .read(passwordStrengthCheckerProvider.notifier)
          .check('Abcd1234!');
      final s = container.read(passwordStrengthCheckerProvider);
      expect(s.hasMinLength, true);
      expect(s.hasUppercase, true);
      expect(s.hasLowercase, true);
      expect(s.hasDigit, true);
      expect(s.hasSymbol, true);
      expect(s.score, 5);
    });

    test('reset returns to empty', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final n = container.read(passwordStrengthCheckerProvider.notifier);
      n.check('Abcd1234!');
      expect(container.read(passwordStrengthCheckerProvider).score, 5);
      n.reset();
      expect(container.read(passwordStrengthCheckerProvider).score, 0);
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
