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
import './screens/job_list_screen.dart';
import './screens/job_detail_screen.dart';
import './screens/timesheet_screen.dart';
import './screens/sliver_timesheet.dart';
import './screens/sliver_joblist.dart';

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
        ChangeNotifierProvider(
          create: (ctx) => Timesheet(),
        )
      ],
      child: MaterialApp(
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
        home: SliverJobList(),
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
    );
  }
}
