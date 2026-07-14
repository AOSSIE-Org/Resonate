extension StringValidators on String {
  static final _emailRegex = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );

  static final _passwordRegex = RegExp(
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$',
  );

  static final _usernameRegex = RegExp(r'^[a-zA-Z0-9._-]+$');

  static const usernameMinLength = 7;

  bool isValidEmail() => _emailRegex.hasMatch(this);

  bool isValidPassword() => _passwordRegex.hasMatch(this);

  bool isSamePassword(String other) => this == other;


  bool hasMinUsernameLength() => trim().length >= usernameMinLength;

  bool hasValidUsernameFormat() => _usernameRegex.hasMatch(trim());

  bool isValidUsername() => hasMinUsernameLength() && hasValidUsernameFormat();
}
