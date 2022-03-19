import 'dart:math';

import 'package:disso_app/providers/auth.dart';
import 'package:disso_app/screens/auth_screen.dart';
import 'package:disso_app/theme/clip_shadow_path.dart';
import 'package:disso_app/widgets/auth_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

class MockAuth extends Mock implements Auth {
  String? userID;
  String? userToken;

  @override
  var isAdmin = false;

  @override
  Future<void> login(String email, String password, bool isAdminAuth) async {
    userID = 'uid';
    userToken = 'userToken';
    isAdmin = isAdminAuth;
  }

  @override
  Future<void> signup(String email, String password, bool isAdminAuth) async {
    userID = 'uid';
    userToken = 'userToken';
    isAdmin = isAdminAuth;
  }
}

@GenerateMocks([Auth])
void main() {
  late MockAuth mockAuth;
  late Function fx;
  setUp(() {
    mockAuth = MockAuth();
  });

  Widget createWidgetUnderTest(Widget? child) {
    return ChangeNotifierProvider<Auth>(
      create: (_) => mockAuth,
      child: MaterialApp(
        title: 'Disso',
        home: child,
      ),
    );
  }

  group('Auth', () {
    group('UI:', () {
      testWidgets('Clipboard Icon is displayed on the AuthScreen',
          (WidgetTester tester) async {
        AuthScreen page = AuthScreen();
        // MockAuth mockAuth = MockAuth();
        await tester.pumpWidget(createWidgetUnderTest(page));
        //
        expect(find.byIcon(FontAwesomeIcons.clipboardCheck), findsOneWidget);
        // expect(find.byType(ClipShadowPath), findsWidgets);
      });

      testWidgets('Bezier Splash is correctly displayed on the AuthScreen',
          (WidgetTester tester) async {
        AuthScreen page = AuthScreen();
        await tester.pumpWidget(createWidgetUnderTest(page));
        expect(find.byType(ClipShadowPath), findsNWidgets(2));
      });

      testWidgets('Auth Card is displayed on the AuthScreen',
          (WidgetTester tester) async {
        // AuthScreen page = AuthScreen();
        await tester.pumpWidget(createWidgetUnderTest(const AuthScreen()));
        expect(find.byType(AuthCard), findsOneWidget);
      });
    });

    group('login: ', () {
      testWidgets(
          'when email & password is valid and user selects login accept login auth',
          (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest(const AuthScreen()));

        Finder emailField = find.byKey(const Key('email'));
        await tester.enterText(emailField, 'email@123');

        Finder passwordField = find.byKey(const Key('password'));
        await tester.enterText(passwordField, 'password');

        await tester.tap(find.byKey(const Key('initAuthButton')));

        expect(mockAuth.isAdmin, false);
        expect(mockAuth.userID, 'uid');
        expect(mockAuth.userToken, 'userToken');
      });

      testWidgets(
          'when email & password is empty and user selects login, deny auth',
          (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest(const AuthScreen()));

        Finder emailField = find.byKey(const Key('email'));
        await tester.enterText(emailField, '');

        Finder passwordField = find.byKey(const Key('password'));
        await tester.enterText(passwordField, '');

        await tester.tap(find.byKey(const Key('initAuthButton')));
        await tester.pumpAndSettle();

        expect(mockAuth.isAdmin, false);
        expect(mockAuth.userID, null);
        expect(mockAuth.userToken, null);
      });

      testWidgets(
          'when email is valid & password invalid and user selects login, deny auth',
          (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest(const AuthScreen()));

        Finder emailField = find.byKey(const Key('email'));
        await tester.enterText(emailField, 'email@123');

        Finder passwordField = find.byKey(const Key('password'));
        await tester.enterText(passwordField, '');

        await tester.tap(find.byKey(const Key('initAuthButton')));

        expect(mockAuth.isAdmin, false);
        expect(mockAuth.userID, null);
        expect(mockAuth.userToken, null);
      });

      testWidgets(
          'when email is invalid & password valid and user selects login, deny auth',
          (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest(const AuthScreen()));

        Finder emailField = find.byKey(const Key('email'));
        await tester.enterText(emailField, 'invalidEmail');

        Finder passwordField = find.byKey(const Key('password'));
        await tester.enterText(passwordField, 'password');

        await tester.tap(find.byKey(const Key('initAuthButton')));

        expect(mockAuth.isAdmin, false);
        expect(mockAuth.userID, null);
        expect(mockAuth.userToken, null);
      });
    });

    group('signUp: ', () {
      testWidgets('authCard Expands upon Sign up button press',
          (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest(const AuthScreen()));

        Finder switchAuthForm = find.byKey(const Key('switchAuthMode'));
        await tester.tap(switchAuthForm);
        await tester.pumpAndSettle();

        expect(find.byKey(Key('adminKeyField')), findsOneWidget);
        expect(find.byKey(Key('confirmPasswordField')), findsOneWidget);
      });

      testWidgets(
          'when signing up with valid email, valid passwords accept user auth',
          (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest(const AuthScreen()));

        Finder switchAuthForm = find.byKey(const Key('switchAuthMode'));
        await tester.tap(switchAuthForm);
        await tester.pumpAndSettle();

        Finder emailField = find.byKey(const Key('email'));
        await tester.enterText(emailField, 'email@123');

        Finder passwordField = find.byKey(const Key('password'));
        await tester.enterText(passwordField, 'password');

        Finder confirmPasswordField =
            find.byKey(const Key('confirmPasswordField'));
        await tester.enterText(confirmPasswordField, 'password');

        await tester.tap(find.byKey(const Key('initAuthButton')));

        expect(mockAuth.isAdmin, false);
        expect(mockAuth.userID, 'uid');
        expect(mockAuth.userToken, 'userToken');
      });

      testWidgets(
          'when signing up, with valid email, passwords and valid AdminKey accept admin auth',
          (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest(const AuthScreen()));

        Finder switchAuthForm = find.byKey(const Key('switchAuthMode'));
        await tester.tap(switchAuthForm);
        await tester.pumpAndSettle();

        Finder emailField = find.byKey(const Key('email'));
        await tester.enterText(emailField, 'email@123');

        Finder passwordField = find.byKey(const Key('password'));
        await tester.enterText(passwordField, 'password');

        Finder confirmPasswordField =
            find.byKey(const Key('confirmPasswordField'));
        await tester.enterText(confirmPasswordField, 'password');

        Finder adminKeyField = find.byKey(const Key('adminKeyField'));
        await tester.enterText(adminKeyField, 'dissoAdminKey');

        await tester.tap(find.byKey(const Key('initAuthButton')));

        expect(mockAuth.isAdmin, true);
        expect(mockAuth.userID, 'uid');
        expect(mockAuth.userToken, 'userToken');
      });

      testWidgets(
          'when user is signing up, with valid email, passwords and invalid AdminKey deny auth',
          (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest(const AuthScreen()));

        Finder switchAuthForm = find.byKey(const Key('switchAuthMode'));
        await tester.tap(switchAuthForm);
        await tester.pumpAndSettle();

        Finder emailField = find.byKey(const Key('email'));
        await tester.enterText(emailField, 'email@123');

        Finder passwordField = find.byKey(const Key('password'));
        await tester.enterText(passwordField, 'password');

        Finder confirmPasswordField =
            find.byKey(const Key('confirmPasswordField'));
        await tester.enterText(confirmPasswordField, 'password');

        Finder adminKeyField = find.byKey(const Key('adminKeyField'));
        await tester.enterText(adminKeyField, 'invalid Admin Key');

        await tester.tap(find.byKey(const Key('initAuthButton')));

        expect(mockAuth.isAdmin, false);
        expect(mockAuth.userID, null);
        expect(mockAuth.userToken, null);
      });

      testWidgets(
          'when user is signing up, invalid email, password and confirm passwords denys user auth',
          (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest(const AuthScreen()));

        Finder switchAuthForm = find.byKey(const Key('switchAuthMode'));
        await tester.tap(switchAuthForm);
        await tester.pumpAndSettle();

        Finder emailField = find.byKey(const Key('email'));
        await tester.enterText(emailField, '');

        Finder passwordField = find.byKey(const Key('password'));
        await tester.enterText(passwordField, '');

        Finder confirmPasswordField =
            find.byKey(const Key('confirmPasswordField'));
        await tester.enterText(confirmPasswordField, 'x');

        await tester.tap(find.byKey(const Key('initAuthButton')));

        expect(mockAuth.isAdmin, false);
        expect(mockAuth.userID, null);
        expect(mockAuth.userToken, null);
      });

      testWidgets('when user is signing up, with empty fields denys user auth',
          (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest(const AuthScreen()));

        Finder switchAuthForm = find.byKey(const Key('switchAuthMode'));
        await tester.tap(switchAuthForm);
        await tester.pumpAndSettle();

        Finder emailField = find.byKey(const Key('email'));
        await tester.enterText(emailField, '');

        Finder passwordField = find.byKey(const Key('password'));
        await tester.enterText(passwordField, '');

        Finder confirmPasswordField =
            find.byKey(const Key('confirmPasswordField'));
        await tester.enterText(confirmPasswordField, '');

        Finder adminKeyField = find.byKey(const Key('adminKeyField'));
        await tester.enterText(adminKeyField, '');

        await tester.tap(find.byKey(const Key('initAuthButton')));

        expect(mockAuth.isAdmin, false);
        expect(mockAuth.userID, null);
        expect(mockAuth.userToken, null);
      });
    });
  });
}
