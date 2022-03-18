import 'package:disso_app/providers/auth.dart';
import 'package:disso_app/providers/jobs_firebase.dart';
import 'package:disso_app/screens/edit_job_screen.dart';
import 'package:disso_app/screens/list_job_screen.dart';
import 'package:disso_app/widgets/app_drawer.dart';
import 'package:disso_app/widgets/profile_search_sliver.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'mock_test_class.dart';

void main() {
  late MockJobsFirebase? mockJobsFirebase;
  late MockAuth? mockAuth;

  setUp(() {
    mockJobsFirebase = MockJobsFirebase();
    mockAuth = MockAuth();
    GoogleFonts.config.allowRuntimeFetching = false;
  });
  Widget createWidgetUnderTest(child) {
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
        home: EditJobScreen(jobId: null),
      ),
    );
  }

  group('EditJob UI:', () {
    testWidgets('Refresh button is displayed on the List Job Screen',
        (WidgetTester tester) async {
      tester.binding.window.physicalSizeTestValue = Size(0, 400);
      await tester.pumpWidget(createWidgetUnderTest(const ListJobScreen()));

      expect(find.byKey(const Key('saveFormIconButton')), findsOneWidget);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    });

    testWidgets('Edit JOob Text is displayed on the List Job Screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const ListJobScreen()));

      expect(find.byKey(const Key('JobListTitle')), findsOneWidget);
    });

    // testWidgets('Loading spinner displayed on the List Job Screen',
    //     (WidgetTester tester) async {
    //   await tester.pumpWidget(createWidgetUnderTest(const ListJobScreen()));
    //   await tester.pump();
    //   expect(find.byKey(const Key('ListJobLoadingAnimation')), findsNothing);
    // });
  });

  // group('ListJob UI:', () {
  //   testWidgets('Profile Search bar is displayed on the List Job Screen',
  //       (WidgetTester tester) async {
  //     await tester.pumpWidget(createWidgetUnderTest(const ListJobScreen()));

  //     expect(find.byType(ProfileSearchSliver), findsOneWidget);
  //   });

  //   testWidgets('Refresh button is displayed on the List Job Screen',
  //       (WidgetTester tester) async {
  //     await tester.pumpWidget(createWidgetUnderTest(const ListJobScreen()));

  //     expect(find.byKey(const Key('refreshJobListIcon')), findsOneWidget);
  //   });

  //   testWidgets('Job List Text is displayed on the List Job Screen',
  //       (WidgetTester tester) async {
  //     await tester.pumpWidget(createWidgetUnderTest(const ListJobScreen()));

  //     expect(find.byKey(const Key('JobListTitle')), findsOneWidget);
  //   });

  //   // testWidgets('Loading spinner displayed on the List Job Screen',
  //   //     (WidgetTester tester) async {
  //   //   await tester.pumpWidget(createWidgetUnderTest(const ListJobScreen()));
  //   //   await tester.pump();
  //   //   expect(find.byKey(const Key('ListJobLoadingAnimation')), findsNothing);
  //   // });
  // });
}
