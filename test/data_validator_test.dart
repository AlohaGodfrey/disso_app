import 'package:flutter_test/flutter_test.dart';
import 'package:disso_app/helpers/data_validator.dart';
import 'package:disso_app/providers/auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

//unit testing the auth and job entry data validation

void main() {
  setUp(() {});

  group("Auth: ", () {
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
  });

  group("Jobs Data:", () {
    test('When Job Title is null return error string', () {
      final result = JobDataValidator.title(null);
      expect(result, 'return is null');
    });

    test('When Job Title is empty return error string', () {
      final result = JobDataValidator.title('');
      expect(result, 'Please provide a Title.');
    });

    test('When Job Title is valid return null', () {
      final result = JobDataValidator.title('Valid Job Title');
      expect(result, null);
    });

    test('When Job postcode is null return error string', () {
      final result = JobDataValidator.postcode(null);
      expect(result, 'return is null');
    });

    test('When Job postcode is empty return error string', () {
      final result = JobDataValidator.postcode('');
      expect(result, 'Please provide an Area Postcode');
    });

    test(
        'When Job postcode is shorter than minimum threshold return error string',
        () {
      final result = JobDataValidator.postcode('HP12');
      expect(result, 'Should be at least five characters long');
    });

    test(
        'When Job postcode is longer than maximum threshold return error string',
        () {
      final result = JobDataValidator.postcode('MaximumHP12');
      expect(result, 'Postcode should be 5-8 characters long');
    });
  });
}
