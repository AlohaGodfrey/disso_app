import 'package:disso_app/providers/Job.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import './providers/Jobs.dart';
import './theme/palette.dart';
import './widgets/job_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => Jobs(),
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
                  fontFamily: 'Raleway',
                ),
              ),
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final JobList = Provider.of<Jobs>(context).jobItems; //access the joblist
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 24),
          physics: const BouncingScrollPhysics(),
          itemCount: JobList.length,
          itemBuilder: (context, index) {
            return JobCard(
              nameLocation: JobList[index].title,
              lightConfig: JobList[index].description,
            );
            // return JobCard(job: JobList[index]);
          },
          separatorBuilder: (context, index) {
            return const SizedBox(
              height: 12,
            );
          },
        ));
  }
}
