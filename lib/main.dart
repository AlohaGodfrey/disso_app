import 'package:disso_app/providers/jobs_firebase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './models/job_model.dart';
import './theme/palette.dart';
import './routes/routes.dart';
import './providers/auth.dart';
import './providers/jobs_firebase.dart';
import './providers/timesheets_firebase.dart';

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
        ChangeNotifierProxyProvider<Auth, JobsFirebase>(
          create: (context) => JobsFirebase([], authToken: '', authUserId: ''),
          update: (ctx, auth, previousJobs) => JobsFirebase(
              previousJobs == null ? [] : previousJobs.jobItems,
              authToken: auth.token == null ? '' : auth.token as String,
              authUserId: auth.userId == null ? '' : auth.userId as String),
        ),
        //products uses proxy Provider to depend on the Auth
        //object. whenever auth changes, Products gets rebuilt.
        //important to call Auth higher in the build tree first.
        ChangeNotifierProxyProvider<Auth, TimesheetsFirebase>(
          //pass dummy arguments first. then grab the token
          create: (ctx) => TimesheetsFirebase('', '', []),
          update: (ctx, auth, previousTimesheet) => TimesheetsFirebase(
              auth.token == null ? '' : auth.token as String,
              auth.userId == null ? '' : auth.userId as String,
              previousTimesheet == null ? [] : previousTimesheet.timesheet),
        ),
      ],
      child: Consumer<Auth>(builder: (context, auth, _) {
        return MaterialApp(
          title: 'Disso',
          debugShowCheckedModeBanner: false,
          theme: paletteThemeData(),
          initialRoute: RouteManager.autoLoginConfig,
          onGenerateRoute: RouteManager.generateRoute,
        );
      }),
    );
  }
}
