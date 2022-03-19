import 'dart:math';

import 'package:disso_app/models/job_model.dart';
import 'package:disso_app/providers/auth.dart';
import 'package:disso_app/providers/jobs_firebase.dart';
import 'package:disso_app/screens/edit_job_screen.dart';
import 'package:disso_app/widgets/app_drawer.dart';
import 'package:disso_app/widgets/profile_search_sliver.dart';
import 'package:disso_app/widgets/profile_sliver.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:universal_html/html.dart';

import 'mock_test_class.dart';

void main() {
  late MockJobsFirebase? mockJobsFirebase;
  late MockAuth? mockAuth;

  setUp(() {
    mockJobsFirebase = MockJobsFirebase();
    mockAuth = MockAuth();
    GoogleFonts.config.allowRuntimeFetching = false;
  });
  Widget createWidgetUnderTest(Widget? child) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(
          create: (_) => mockAuth as Auth,
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
