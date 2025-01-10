class Validator {
  Validator._();

  static const _regexUsername = r'^[a-zA-Z0-9]{6,}$';

  // static const _emailRegExpString =
  //     r'[a-zA-Z0-9\+\.\_\%\-\+]{1,256}\@[a-zA-Z0-9]'
  //     r'[a-zA-Z0-9\-]{0,64}(\.[a-zA-Z0-9][a-zA-Z0-9\-]{0,25})+';
  // static final _emailRegex = RegExp(_emailRegExpString, caseSensitive: false);

  static bool isValidPassword(String password) => password.length >= 8;

  // static bool isValidEmail(String email) => _emailRegex.hasMatch(email);

  static bool isValidUserName(String userName) => RegExp(_regexUsername, caseSensitive: false).hasMatch(userName);
}
