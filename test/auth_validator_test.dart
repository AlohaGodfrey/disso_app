import 'package:flutter_test/flutter_test.dart';
import 'package:disso_app/helpers/auth_validator.dart';
import 'package:disso_app/providers/auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

//unit testing the auth data validators

void main() {
  setUp(() {});
  test('Empty email returns error string', () {
    final result = AuthValidator.email(null);
    expect(result, 'Value is Null');
  });

  test('Invalid email returns error string', () {
    final result = AuthValidator.email('InvalidEmail');
    expect(result, 'Invalid email!');
  });

  test('Valid email returns null', () {
    final result = AuthValidator.email('Test@Email');
    expect(result, null);
  });

  test('Empty initial password returns error string', () {
    final result = AuthValidator.password(null);
    expect(result, 'Value is Null');
  });

  test('Initial password less than five characters returns error string', () {
    final result = AuthValidator.password('Pass');
    expect(result, 'Password is too short!');
  });

  test('Inital password as \'\' returns error string', () {
    final result = AuthValidator.password('');
    expect(result, 'Password is too short!');
  });

  test('Valid initial password returns null', () {
    final result = AuthValidator.password('validPassword');
    expect(result, null);
  });

  test('Confirm password with Login AuthMode returns null', () {
    final result = AuthValidator.confirmPassword(
        'validPassword', AuthMode.login, 'initialPassword');
    expect(result, null);
  });

  test('Correct Confirm password with SignUp screen returns null', () {
    final result = AuthValidator.confirmPassword(
        'validPassword', AuthMode.signup, 'validPassword');
    expect(result, null);
  });

  test('Incorrect Confirm password with SignUp Screen returns error string',
      () {
    final result = AuthValidator.confirmPassword(
        'invalidPassword', AuthMode.signup, 'Password');
    expect(result, 'Passwords do not match!');
  });

  test('Admin Key with Login AuthMode returns null', () {
    final result = AuthValidator.confirmAdminKey(
        'invalidAdminKey', AuthMode.login, Auth.adminSignUpKey);
    expect(result, null);
  });

  test('Correct Admin Key with SignUp screen returns null', () {
    final result = AuthValidator.confirmAdminKey(
        'dissoAdminKey', AuthMode.signup, Auth.adminSignUpKey);
    expect(result, null);
  });

  test('Incorrect Admin Key with SignUp Screen returns error string', () {
    final result = AuthValidator.confirmAdminKey(
        'invalidAdminKey', AuthMode.signup, Auth.adminSignUpKey);
    expect(result, 'Invalid Admin Key!');
  });
}
