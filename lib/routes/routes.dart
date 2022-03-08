import 'package:flutter/material.dart';

import '../models/job_model.dart';
import '../widgets/auto_login_config.dart';
import '../theme/splash_screen.dart';
import '../screens/active_job_screen.dart';
import '../screens/auth_screen.dart';
import '../screens/detail_job_screen.dart';
import '../screens/edit_job_screen.dart';
import '../screens/list_job_screen.dart';
import '../screens/timesheet_screen.dart';
import '../screens/maps_screen.dart';

//Screen Navigation Manager

class RouteManager {
  static const String autoLoginConfig = '/';
  static const String authScreen = '/auth';
  static const String splashScreen = '/splash-screen';
  static const String listJobScreen = '/list-jobs';
  static const String detailJobScreen = '/detail-jobs';
  static const String editJobScreen = '/edit-jobs';
  static const String activeJobScreen = '/active-job';
  static const String timesheetScreen = '/timesheet';
  static const String mapsGoogleScreen = '/maps-google';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case autoLoginConfig:
        return MaterialPageRoute(
          builder: (context) => const AutoLoginConfig(),
        );

      case authScreen:
        return MaterialPageRoute(
          builder: (context) => const AuthScreen(),
        );

      case splashScreen:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );

      case listJobScreen:
        return MaterialPageRoute(
          builder: (context) => const ListJobScreen(),
        );

      case detailJobScreen:
        var arguments = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (context) =>
              DetailJobScreen(arguments['jobID'], arguments['refreshJobList']),
        );

      case editJobScreen:
        final jobId = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (context) => EditJobScreen(jobId: jobId),
        );

      case activeJobScreen:
        final currentJob = settings.arguments as Job;
        return MaterialPageRoute(
          builder: (context) => ActiveJobScreen(currentJob),
        );

      case timesheetScreen:
        return MaterialPageRoute(
          builder: (context) => const TimesheetScreen(),
        );

      case mapsGoogleScreen:
        return MaterialPageRoute(
          builder: (context) => MapsScreen(),
        );

      default:
        throw const FormatException('Route not found! Check routes again!');
    }
  }
}
