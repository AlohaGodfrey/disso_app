enum AuthMode { signup, login }

//used for testing
class AuthValidator {
  static String? email(String? value) {
    if (value == null) {
      return 'Value is Null';
    }
    if (value.isEmpty || !value.contains('@')) {
      return 'Invalid email!';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null) {
      return 'Value is Null';
    }
    if (value.isEmpty || value.length < 5) {
      return 'Password is too short!';
    }
    return null;
  }

  static String? confirmPassword(
      String? value, AuthMode authMode, String passwordControllerText) {
    if (authMode == AuthMode.signup) {
      if (value != passwordControllerText) {
        return 'Passwords do not match!';
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static String? confirmAdminKey(
      String? value, AuthMode authMode, String authAdminKey) {
    if (authMode == AuthMode.signup) {
      if (value != authAdminKey) {
        return 'Invalid Admin Key!';
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
