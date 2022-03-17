import 'package:disso_app/providers/auth.dart';
import 'package:disso_app/providers/jobs_firebase.dart';
import 'package:disso_app/screens/list_job_screen.dart';
import 'package:disso_app/widgets/app_drawer.dart';
import 'package:disso_app/widgets/profile_search_sliver.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'mock_test_class.dart';

void main() {
  late MockJobsFirebase? mockJobsFirebase;
  late MockAuth? mockAuth;
  setUp(() {
    mockJobsFirebase = MockJobsFirebase();
    mockAuth = MockAuth();
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
      child: const MaterialApp(
        home: ListJobScreen(),
      ),
    );
  }

  group('ListJob UI:', () {
    testWidgets('Profile Search bar is displayed on the List Job Screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const ListJobScreen()));

      expect(find.byType(ProfileSearchSliver), findsOneWidget);
    });

    testWidgets('Refresh button is displayed on the List Job Screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const ListJobScreen()));

      expect(find.byKey(const Key('refreshJobListIcon')), findsOneWidget);
    });

    testWidgets('Job List Text is displayed on the List Job Screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const ListJobScreen()));

      expect(find.byKey(const Key('JobListTitle')), findsOneWidget);
    });

    testWidgets('All Jobs displayed on the List Job Screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const ListJobScreen()));

      expect(find.byKey(const Key('SingleJobCard')), findsNWidgets(4));
    });
  });
}
