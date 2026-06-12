extension StringValidators on String {
  static final _emailRegex = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );

  static final _passwordRegex = RegExp(
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$',
  );

  bool isValidEmail() => _emailRegex.hasMatch(this);

  bool isValidPassword() => _passwordRegex.hasMatch(this);

  bool isSamePassword(String other) => this == other;
}
