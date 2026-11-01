class PasswordStrength {
  const PasswordStrength({
    required this.hasMinLength,
    required this.hasUppercase,
    required this.hasLowercase,
    required this.hasDigit,
    required this.hasSymbol,
  });

  static const empty = PasswordStrength(
    hasMinLength: false,
    hasUppercase: false,
    hasLowercase: false,
    hasDigit: false,
    hasSymbol: false,
  );

  final bool hasMinLength;
  final bool hasUppercase;
  final bool hasLowercase;
  final bool hasDigit;
  final bool hasSymbol;

  int get score =>
      (hasMinLength ? 1 : 0) +
      (hasUppercase ? 1 : 0) +
      (hasLowercase ? 1 : 0) +
      (hasDigit ? 1 : 0) +
      (hasSymbol ? 1 : 0);

  bool get meetsFormRequirements =>
      hasUppercase && hasLowercase && hasDigit;

  static PasswordStrength evaluate(String password) {
    if (password.isEmpty) return empty;
    return PasswordStrength(
      hasMinLength: password.length >= 8,
      hasUppercase: _upper.hasMatch(password),
      hasLowercase: _lower.hasMatch(password),
      hasDigit: _digit.hasMatch(password),
      hasSymbol: _symbol.hasMatch(password),
    );
  }

  static final _upper = RegExp(r'[A-Z]');
  static final _lower = RegExp(r'[a-z]');
  static final _digit = RegExp(r'[0-9]');
  static final _symbol = RegExp(r'[^\w\s]');
}
