import 'package:resonate/features/auth/model/password_strength.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/password_strength_notifier.g.dart';

@riverpod
class PasswordStrengthChecker extends _$PasswordStrengthChecker {
  @override
  PasswordStrength build() => PasswordStrength.empty;

  void check(String password) {
    state = PasswordStrength.evaluate(password);
  }

  void reset() {
    state = PasswordStrength.empty;
  }
}
