import 'dart:math';

import 'package:disso_app/providers/auth.dart';
import 'package:disso_app/providers/jobs_firebase.dart';
import 'package:disso_app/screens/edit_job_screen.dart';
import 'package:disso_app/screens/list_job_screen.dart';
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
    });
  });
}
