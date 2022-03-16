import 'dart:math';

import 'package:disso_app/providers/auth.dart';
import 'package:disso_app/screens/auth_screen.dart';
import 'package:disso_app/theme/clip_shadow_path.dart';
import 'package:disso_app/widgets/auth_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockAuth extends Mock implements Auth {}

void main() {
  late MockAuth mockAuth;

  setUp(() {
    mockAuth = MockAuth();
  });

  Widget createWidgetUnderTest(Widget child) {
    return ChangeNotifierProvider<Auth>(
      create: (_) => mockAuth,
      child: const MaterialApp(
        title: 'Disso',
        home: AuthScreen(),
      ),
    );
  }

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

  testWidgets('When email and password is empty, Login attempt is denied',
      (WidgetTester tester) async {
    // AuthScreen page = AuthScreen();
    await tester.pumpWidget(createWidgetUnderTest(const AuthScreen()));
    expect(find.byType(AuthCard), findsOneWidget);
  });
}
