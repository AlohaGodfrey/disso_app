import 'package:disso_app/providers/job.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'providers/jobs.dart';
import './theme/palette.dart';
import './widgets/job_card.dart';
import './screens/job_list_screen.dart';
import './screens/job_detail_screen.dart';

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
          create: (ctx) => Jobs(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          //uses custom theme pallete
          primarySwatch: Palette.kToDark,
          canvasColor: const Color.fromRGBO(246, 246, 246, 1),
          appBarTheme: const AppBarTheme(
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
        home: JobListScreen(),
        //app navigation ur routes or navigator
        routes: {
          JobDetailScreen.routeName: (ctx) => JobDetailScreen(),
        },
      ),
    );
  }
}
