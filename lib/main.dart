import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import './models/job.dart';
import './screens/job_active_screen.dart';
import './providers/jobs.dart';
import './providers/timesheet.dart';
import './providers/auth.dart';
import './theme/palette.dart';
import './widgets/job_card.dart';
import 'screens/legacy_job_list_screen.dart';
import './screens/job_detail_screen.dart';
import 'screens/legacy_timesheet_screen.dart';
import './screens/sliver_timesheet.dart';
import './screens/sliver_joblist.dart';
import './screens/auth_screen_bezier.dart';
import './screens/bezier_splash_screen.dart';

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
        ChangeNotifierProvider(
          create: (ctx) => Jobs(),
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
          theme: ThemeData(
            //uses custom theme pallete
            primarySwatch: Palette.kToDark,
            canvasColor: const Color.fromRGBO(246, 246, 246, 1),
            appBarTheme: const AppBarTheme(
              centerTitle: true,
              titleTextStyle: TextStyle(
                fontSize: 24,
                fontFamily: 'Lato',
              ),
            ),
            textTheme: ThemeData.light().textTheme.copyWith(
                  headline6: const TextStyle(
                    fontSize: 24,
                    fontFamily: 'Anton',
                  ),
                ),
          ),
          // home: const MyHomePage(title: 'Flutter Demo Home Page'),
          home: auth.isAuth
              ? SliverJobList()
              : FutureBuilder(
                  //attempt to auto login
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapashot) =>
                      authResultSnapashot.connectionState ==
                              ConnectionState.waiting
                          //show splash screen during the auto-login
                          //attempt. if failed. show auth screen
                          ? SplashScreen() // : AuthScreen()
                          : AuthScreen()),

          //app navigation ur routes or navigator
          routes: {
            JobListScreen.routeName: (ctx) => JobListScreen(),
            JobDetailScreen.routeName: (ctx) => JobDetailScreen(),
            JobActiveScreen.routeName: (ctx) => JobActiveScreen(),
            TimesheetScreen.routeName: (ctx) => TimesheetScreen(),
            SliverTimesheet.routeName: (ctx) => SliverTimesheet(),
            SliverJobList.routeName: (ctx) => SliverJobList(),
          },
        ),
      ),
    );
  }
}
