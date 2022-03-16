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

class JobDataValidator {
  static String? title(String? value) {
    if (value == null) {
      return 'return is null';
    } else if (value.isEmpty) {
      return 'Please provide a Title.';
    }
    return null;
  }

  static String? postcode(String? value) {
    if (value == null) {
      return 'return is null';
    } else if (value.isEmpty) {
      return 'Please provide an Area Postcode';
    }
    if (value.length < 5) {
      return 'Should be at least five characters long';
    }
    if (value.length > 8) {
      return 'Postcode should be 5-8 characters long';
    }

    return null;
  }

  static String? payRate(String? value) {
    if (value == null) {
      return 'return is null';
      //needed for null safety checks in flutter v1.12^
    }
    if (value.isEmpty) {
      return 'Please enter a Price';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number.';
    }
    if (double.parse(value) <= 0) {
      return 'Please enter a number greater than zero.';
    }
    return null;
  }
}
