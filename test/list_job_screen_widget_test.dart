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

import 'mock_test_class.dart';

void main() {
  late MockJobsFirebase? mockJobsFirebase;
  late MockAuth? mockAuth;

  setUp(() {
    mockJobsFirebase = MockJobsFirebase();
    mockAuth = MockAuth();
    GoogleFonts.config.allowRuntimeFetching = false;
  });
  Widget createWidgetUnderTest() {
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
    testWidgets('Save form button is displayed on the Edit Job Screen',
        (WidgetTester tester) async {
      // tester.binding.window.physicalSizeTestValue = Size(0, 400);
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byKey(const Key('saveFormIconButton')), findsOneWidget);
      // addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    });

    // testWidgets('Edit JOob Text is displayed on the List Job Screen',
    //     (WidgetTester tester) async {
    //   await tester.pumpWidget(createWidgetUnderTest(const ListJobScreen()));

    //   expect(find.byKey(const Key('JobListTitle')), findsOneWidget);
    // });

    testWidgets('Profile bar is displayed on the List Job Screen',
        (WidgetTester tester) async {
      // tester.binding.window.physicalSizeTestValue = Size(0, 400);

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(ProfileSliver), findsOneWidget);
      // addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    });

    // testWidgets('Contextual hint is displayed on the List Job Screen',
    //     (WidgetTester tester) async {
    //   // tester.binding.window.physicalSizeTestValue = Size(0, 400);

    //   await tester.pumpWidget(createWidgetUnderTest());
    //   await tester.pump();

    //   expect(find.byKey(const Key('JobCard')), findsOneWidget);
    //   // addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    // });

    // testWidgets(
    //     'Help prompt displays dialog on the Edit Job Screen,once clicked',
    //     (WidgetTester tester) async {
    //   // await tester.binding.setSurfaceSize(Size(400, 400));

    //   await tester.pumpWidget(createWidgetUnderTest());
    //   expect(find.text('Edit/Add a new job'), findsNothing);

    //   await tester.tap(find.byKey(const Key('contextHelpHint')));
    //   await tester.pumpAndSettle();

    //   expect(find.text('Edit/Add a new job'), findsOneWidget);
    //   // addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    //   // await tester.binding.setSurfaceSize(null);
    // });

    // testWidgets('Loading spinner displayed on the List Job Screen',
    //     (WidgetTester tester) async {
    //   await tester.pumpWidget(createWidgetUnderTest(const ListJobScreen()));
    //   await tester.pump();
    //   expect(find.byKey(const Key('ListJobLoadingAnimation')), findsNothing);
    // });

    testWidgets('Job List Text is displayed on the List Job Screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('New Job Edit'), findsOneWidget);
    });
    testWidgets('Profile Search bar is displayed on the List Job Screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(ProfileSliver), findsOneWidget);
    });
  });

  // group('ListJob UI:', () {

  //   testWidgets('Refresh button is displayed on the List Job Screen',
  //       (WidgetTester tester) async {
  //     await tester.pumpWidget(createWidgetUnderTest(const ListJobScreen()));

  //     expect(find.byKey(const Key('refreshJobListIcon')), fqindsOneWidget);
  //   });s

  //   // testWidgets('Loading spinner displayed on the List Job Screen',
  //   //     (WidgetTester tester) async {
  //   //   await tester.pumpWidget(createWidgetUnderTest(const ListJobScreen()));
  //   //   await tester.pump();
  //   //   expect(find.byKey(const Key('ListJobLoadingAnimation')), findsNothing);
  //   // });
  // });
}
