import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/job_active_screen.dart';
import './providers/jobs.dart';
import './providers/timesheet.dart';
import './providers/auth.dart';
import './theme/palette.dart';
import './screens/job_detail_screen.dart';
import './screens/timesheet_screen.dart';
import './screens/job_list_screen.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';
import 'screens/edit_job_screen.dart';
import '../models/job_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Jobs>(
          create: (context) => Jobs([
            Job(
              id: 'p1',
              title: 'Islington',
              description: 'Two way lights',
              endDate: DateTime.now(),
              postcode: 'HP11 2et',
            ),
          ], authToken: '', authUserId: ''),
          update: (ctx, auth, previousJobs) => Jobs(
              previousJobs == null ? [] : previousJobs.jobItems,
              authToken: auth.token == null ? '' : auth.token as String,
              authUserId: auth.userId == null ? '' : auth.userId as String),
        ),
        //products uses proxy Provider to depend on the Auth
        //object. whenever auth changes, Products gets rebuilt.
        //important to call Auth higher in the build tree first.
        ChangeNotifierProxyProvider<Auth, Timesheet>(
          //pass dummy arguments first. then grab the token
          create: (ctx) => Timesheet('', '', []),
          update: (ctx, auth, previousTimesheet) => Timesheet(
              auth.token == null ? '' : auth.token as String,
              auth.userId == null ? '' : auth.userId as String,
              previousTimesheet == null ? [] : previousTimesheet.timesheet),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: 'Flutter Demo',
          theme: paletteThemeData(),

          // home: AuthScreen(),
          home: auth.isAuth
              ? JobListScreen()
              : FutureBuilder(
                  //attempt to auto login
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapashot) =>
                      authResultSnapashot.connectionState ==
                              ConnectionState.waiting
                          //show splash screen during the auto-login
                          //attempt. if failed. show auth screen
                          ? SplashScreen() // : AuthScreen()
                          : AuthScreen(),
                ),

          //app navigation ur routes or navigator
          routes: {
            JobListScreen.routeName: (ctx) => JobListScreen(),
            JobDetailScreen.routeName: (ctx) => JobDetailScreen(),
            JobActiveScreen.routeName: (ctx) => JobActiveScreen(),
            TimesheetScreen.routeName: (ctx) => TimesheetScreen(),
            TimesheetScreen.routeName: (ctx) => TimesheetScreen(),
            JobListScreen.routeName: (ctx) => JobListScreen(),
            EditJobScreen.routeName: (ctx) => EditJobScreen(),
          },
        ),
      ),
    );
  }
}
