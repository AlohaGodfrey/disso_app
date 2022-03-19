import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';

import 'package:disso_app/theme/clip_shadow_path.dart';
import 'package:disso_app/providers/jobs_firebase.dart';
import 'package:disso_app/screens/edit_job_screen.dart';
import 'package:disso_app/screens/list_job_screen.dart';
import 'package:disso_app/screens/auth_screen.dart';
import 'package:disso_app/widgets/auth_card.dart';
import 'package:disso_app/providers/auth.dart';

import 'mock_test_class.dart';

void main() {
  late MockJobsFirebase? mockJobsFirebase;
  late MockAuth mockAuth;
  // late MockAuth? mockAuth;

  setUp(() {
    mockJobsFirebase = MockJobsFirebase();
    mockAuth = MockAuth();
    GoogleFonts.config.allowRuntimeFetching = false;
  });
  Widget createWidgetUnderTest(Widget? child) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(
          // create: (_) => mockAuth as Auth,
          create: (_) => mockAuth,
        ),
        ChangeNotifierProxyProvider<Auth, JobsFirebase>(
          create: (context) => mockJobsFirebase as JobsFirebase,
          update: (ctx, auth, previousJobs) => mockJobsFirebase as JobsFirebase,
        ),
      ],
      child: MaterialApp(
        // home: EditJobScreen(jobId: null),
        // home: child ?? EditJobScreen(jobId: null),#
        home: child,
      ),
    );
  }

  //auth screen tests
  group('Auth', () {
    group('UI:', () {
      testWidgets('Clipboard Icon is displayed on the AuthScreen',
          (WidgetTester tester) async {
        AuthScreen page = const AuthScreen();
        // MockAuth mockAuth = MockAuth();
        await tester.pumpWidget(createWidgetUnderTest(page));
        //
        expect(find.byIcon(FontAwesomeIcons.clipboardCheck), findsOneWidget);
        // expect(find.byType(ClipShadowPath), findsWidgets);
      });

      testWidgets('Bezier Splash is correctly displayed on the AuthScreen',
          (WidgetTester tester) async {
        AuthScreen page = const AuthScreen();
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

        expect(find.byKey(const Key('adminKeyField')), findsOneWidget);
        expect(find.byKey(const Key('confirmPasswordField')), findsOneWidget);
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

  //list job screen tests
  group('List Job', () {
    group('UI: ', () {
      testWidgets('refresh button is displayed in App bar',
          (WidgetTester tester) async {
        ListJobScreen page = const ListJobScreen();
        await tester.pumpWidget(createWidgetUnderTest(page));

        expect(find.byKey(const Key('refreshJobListIcon')), findsOneWidget);
        // expect(find.byIcon(FontAwesomeIcons.clipboardCheck), findsOneWidget);
        // expect(find.byType(ClipShadowPath), findsWidgets);
      });

      testWidgets('profile sliver is rendered with search bar',
          (WidgetTester tester) async {
        ListJobScreen page = const ListJobScreen();
        await tester.pumpWidget(createWidgetUnderTest(page));

        expect(
            find.byKey(const Key('ListJob ProfileSearchBar')), findsOneWidget);
      });

      testWidgets('context helpbutton is loaded', (WidgetTester tester) async {
        ListJobScreen page = const ListJobScreen();
        await tester.pumpWidget(createWidgetUnderTest(page));

        expect(find.byKey(const Key('contextHelpHint')), findsOneWidget);
      });

      testWidgets('show correct number of job-card on list job screen',
          (WidgetTester tester) async {
        //internal tests fails due to overflow of unrendered widgets
        //fix is to deploy the tests on actual widgets.
        //the accuracy of widget tests drops.
        //integrations tests are much much better.
        //widget testing is mean for one widget. ahaahahahaahaha
        ListJobScreen page = const ListJobScreen();
        await tester.pumpWidget(createWidgetUnderTest(page));
        //pump twice for loading icon
        await tester.pump();

        //number of job cards dependent of number of jobs created in class
        expect(find.byKey(const Key('JobCard')), findsNWidgets(3));
      });
    });
    group('Logic: ', () {
      testWidgets('search bars query finds specific job',
          (WidgetTester tester) async {
        ListJobScreen page = const ListJobScreen();
        await tester.pumpWidget(createWidgetUnderTest(page));

        Finder jobSearchField = find.byKey(const Key('listJob searchField'));
        await tester.enterText(jobSearchField, 'caledonian');
        await tester.pump();
        expect(find.byKey(const Key('JobCard')), findsOneWidget);
      });

      testWidgets('search bar query with no results show search_off icon',
          (WidgetTester tester) async {
        ListJobScreen page = const ListJobScreen();
        await tester.pumpWidget(createWidgetUnderTest(page));

        Finder jobSearchField = find.byKey(const Key('listJob searchField'));
        await tester.enterText(jobSearchField, 'xxxx');
        await tester.pump();
        // await tester.pumpAndSettle();

        expect(find.byKey(const Key('JobCard')), findsNothing);
        expect(find.text('No results found'), findsOneWidget);
        expect(find.byKey(const Key('search_off Icon')), findsOneWidget);
      });

      testWidgets(
          'when users taps refresh button, app fetches new jobs instace',
          (WidgetTester tester) async {
        ListJobScreen page = const ListJobScreen();
        await tester.pumpWidget(createWidgetUnderTest(page));

        Finder refreshJobsButton = find.byKey(const Key('refreshJobListIcon'));
        await tester.tap(refreshJobsButton);

        expect(
            find.byKey(const Key('ListJobLoadingAnimation')), findsOneWidget);
        verify(mockJobsFirebase?.clearJobList()).called(1);
      });

      testWidgets(
          'when users taps help icon, a dialog opens showing contextual hints',
          (WidgetTester tester) async {
        ListJobScreen page = const ListJobScreen();
        await tester.pumpWidget(createWidgetUnderTest(page));
        expect(find.text('Search and Select jobs'), findsNothing);

        Finder contextHelpHint = find.byKey(const Key('search_Help_Button'));
        await tester.tap(contextHelpHint);
        await tester.pumpAndSettle();

        expect(find.text('Search and Select jobs'), findsOneWidget);
      });
    });
  });

  group('Edit Job', () {
    group('UI: ', () {
      testWidgets('save form button is rendered in App bar',
          (WidgetTester tester) async {
        EditJobScreen page = EditJobScreen(jobId: null);
        await tester.pumpWidget(createWidgetUnderTest(page));

        expect(find.byKey(const Key('save_Form_Icon_Button')), findsOneWidget);
      });

      testWidgets('profile sliver is rendered without search bar',
          (WidgetTester tester) async {
        EditJobScreen page = EditJobScreen(jobId: null);
        await tester.pumpWidget(createWidgetUnderTest(page));

        expect(find.byKey(const Key('basic_profile_sliver')), findsOneWidget);
      });

      testWidgets('context helpbutton is loaded', (WidgetTester tester) async {
        EditJobScreen page = EditJobScreen(jobId: null);
        await tester.pumpWidget(createWidgetUnderTest(page));

        expect(find.byKey(const Key('contextHelpHint')), findsOneWidget);
      });

      testWidgets('Edit Job form is loaded', (WidgetTester tester) async {
        EditJobScreen page = EditJobScreen(jobId: null);
        await tester.pumpWidget(createWidgetUnderTest(page));

        expect(find.byKey(const Key('edit_job_card')), findsOneWidget);
      });
    });
    group('Logic: ', () {
      testWidgets(
          'when user enters valid job data and save button is pressed, no errors displayed',
          (WidgetTester tester) async {
        EditJobScreen page = EditJobScreen(jobId: null);
        await tester.pumpWidget(createWidgetUnderTest(page));

        //title
        Finder editTitleField = find.byKey(const Key('edit_job_title'));
        await tester.enterText(editTitleField, 'Kingston');

        //postcode
        Finder editPostcodeField = find.byKey(const Key('edit_job_postcode'));
        await tester.enterText(editPostcodeField, 'HP1XX');

        //Pay Rate
        Finder editPayrateField = find.byKey(const Key('edit_job_payRate'));
        await tester.enterText(editPayrateField, '13.50');

        //save form button
        Finder saveFormButton = find.byKey(const Key('save_Form_Icon_Button'));
        await tester.tap(saveFormButton);

        //set state and update screen
        await tester.pump();

        //check if correct error message is displayed
        expect(find.text('Please provide a Title.'), findsNothing);
        expect(find.text('Please provide an Area Postcode'), findsNothing);
        expect(find.text('Please enter a Price'), findsNothing);
      });

      testWidgets(
          'when user enters empty job title and save button is pressed, throws string error',
          (WidgetTester tester) async {
        EditJobScreen page = EditJobScreen(jobId: null);
        await tester.pumpWidget(createWidgetUnderTest(page));

        //title
        Finder editTitleField = find.byKey(const Key('edit_job_title'));
        await tester.enterText(editTitleField, '');

        //postcode
        Finder editPostcodeField = find.byKey(const Key('edit_job_postcode'));
        await tester.enterText(editPostcodeField, 'HP1XX');

        //Pay Rate
        Finder editPayrateField = find.byKey(const Key('edit_job_payRate'));
        await tester.enterText(editPayrateField, '13.50');

        //save form button
        Finder saveFormButton = find.byKey(const Key('save_Form_Icon_Button'));
        await tester.tap(saveFormButton);

        //set state and update screen
        await tester.pump();

        //check if correct error message is displayed
        expect(find.text('Please provide a Title.'), findsOneWidget);
        expect(find.text('Please provide an Area Postcode'), findsNothing);
        expect(find.text('Please enter a Price'), findsNothing);
      });

      testWidgets(
          'when user enters job postcode and save button is pressed, throws string error',
          (WidgetTester tester) async {
        EditJobScreen page = EditJobScreen(jobId: null);
        await tester.pumpWidget(createWidgetUnderTest(page));

        //title
        Finder editTitleField = find.byKey(const Key('edit_job_title'));
        await tester.enterText(editTitleField, 'Valid Title');

        //postcode
        Finder editPostcodeField = find.byKey(const Key('edit_job_postcode'));
        await tester.enterText(editPostcodeField, '');

        //Pay Rate
        Finder editPayrateField = find.byKey(const Key('edit_job_payRate'));
        await tester.enterText(editPayrateField, '13.50');

        //save form button
        Finder saveFormButton = find.byKey(const Key('save_Form_Icon_Button'));
        await tester.tap(saveFormButton);

        //set state and update screen
        await tester.pump();

        //check if correct error message is displayed
        expect(find.text('Please provide a Title.'), findsNothing);
        expect(find.text('Please provide an Area Postcode'), findsOneWidget);
        expect(find.text('Please enter a Price'), findsNothing);
      });
      testWidgets(
          'when user enters job postcode with less than five characters and save button is pressed, throws string error',
          (WidgetTester tester) async {
        EditJobScreen page = EditJobScreen(jobId: null);
        await tester.pumpWidget(createWidgetUnderTest(page));

        //title
        Finder editTitleField = find.byKey(const Key('edit_job_title'));
        await tester.enterText(editTitleField, 'Valid Title');

        //postcode
        Finder editPostcodeField = find.byKey(const Key('edit_job_postcode'));
        await tester.enterText(editPostcodeField, '1234');

        //Pay Rate
        Finder editPayrateField = find.byKey(const Key('edit_job_payRate'));
        await tester.enterText(editPayrateField, '13.50');

        //save form button
        Finder saveFormButton = find.byKey(const Key('save_Form_Icon_Button'));
        await tester.tap(saveFormButton);

        //set state and update screen
        await tester.pump();

        //check if correct error message is displayed
        expect(find.text('Please provide a Title.'), findsNothing);
        expect(find.text('Should be at least five characters long'),
            findsOneWidget);
        expect(find.text('Please enter a Price'), findsNothing);
      });

      testWidgets(
          'when user enters empty job pay Rate and save button is pressed, throws string error',
          (WidgetTester tester) async {
        EditJobScreen page = EditJobScreen(jobId: null);
        await tester.pumpWidget(createWidgetUnderTest(page));

        //title
        Finder editTitleField = find.byKey(const Key('edit_job_title'));
        await tester.enterText(editTitleField, 'Valid Title');

        //postcode
        Finder editPostcodeField = find.byKey(const Key('edit_job_postcode'));
        await tester.enterText(editPostcodeField, '12345678');

        //Pay Rate
        Finder editPayrateField = find.byKey(const Key('edit_job_payRate'));
        await tester.enterText(editPayrateField, '');

        //save form button
        Finder saveFormButton = find.byKey(const Key('save_Form_Icon_Button'));
        await tester.tap(saveFormButton);

        //set state and update screen
        await tester.pump();

        //check if correct error message is displayed
        expect(find.text('Please provide a Title.'), findsNothing);
        expect(
            find.text('Postcode should be 5-8 characters long'), findsNothing);
        expect(find.text('Please enter a Price'), findsOneWidget);
      });

      testWidgets(
          'when user enters text in job pay Rate and save button is pressed, throws string error',
          (WidgetTester tester) async {
        EditJobScreen page = EditJobScreen(jobId: null);
        await tester.pumpWidget(createWidgetUnderTest(page));

        //title
        Finder editTitleField = find.byKey(const Key('edit_job_title'));
        await tester.enterText(editTitleField, 'Valid Title');

        //postcode
        Finder editPostcodeField = find.byKey(const Key('edit_job_postcode'));
        await tester.enterText(editPostcodeField, '12345678');

        //Pay Rate
        Finder editPayrateField = find.byKey(const Key('edit_job_payRate'));
        await tester.enterText(editPayrateField, 'text');

        //save form button
        Finder saveFormButton = find.byKey(const Key('save_Form_Icon_Button'));
        await tester.tap(saveFormButton);

        //set state and update screen
        await tester.pump();

        //check if correct error message is displayed
        expect(find.text('Please provide a Title.'), findsNothing);
        expect(
            find.text('Postcode should be 5-8 characters long'), findsNothing);
        expect(find.text('Please enter a valid number.'), findsOneWidget);
      });

      testWidgets(
          'when user enters \'0\' in job pay Rate and save button is pressed, throws string error',
          (WidgetTester tester) async {
        EditJobScreen page = EditJobScreen(jobId: null);
        await tester.pumpWidget(createWidgetUnderTest(page));

        //title
        Finder editTitleField = find.byKey(const Key('edit_job_title'));
        await tester.enterText(editTitleField, 'Valid Title');

        //postcode
        Finder editPostcodeField = find.byKey(const Key('edit_job_postcode'));
        await tester.enterText(editPostcodeField, '12345678');

        //Pay Rate
        Finder editPayrateField = find.byKey(const Key('edit_job_payRate'));
        await tester.enterText(editPayrateField, '0');

        //save form button
        Finder saveFormButton = find.byKey(const Key('save_Form_Icon_Button'));
        await tester.tap(saveFormButton);

        //set state and update screen
        await tester.pump();

        //check if correct error message is displayed
        expect(find.text('Please provide a Title.'), findsNothing);
        expect(
            find.text('Postcode should be 5-8 characters long'), findsNothing);
        expect(find.text('Please enter a number greater than zero.'),
            findsOneWidget);
      });
    });
  });
}
