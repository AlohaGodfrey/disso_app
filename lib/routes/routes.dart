import 'package:flutter/material.dart';

import '../models/job_model.dart';
import '../widgets/auto_login_config.dart';
import '../screens/splash_screen.dart';
import '../screens/active_job_screen.dart';
import '../screens/auth_screen.dart';
import '../screens/detail_job_screen.dart';
import '../screens/edit_job_screen.dart';
import '../screens/list_job_screen.dart';
import '../screens/timesheet_screen.dart';
import '../screens/maps_google_screen.dart';

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
          builder: (context) => AutoLoginConfig(),
        );

      case authScreen:
        return MaterialPageRoute(
          builder: (context) => AuthScreen(),
        );

      case splashScreen:
        return MaterialPageRoute(
          builder: (context) => SplashScreen(),
        );

      case listJobScreen:
        return MaterialPageRoute(
          builder: (context) => ListJobScreen(),
        );

      case detailJobScreen:
        final currentJob = settings.arguments as Job;
        return MaterialPageRoute(
          builder: (context) => DetailJobScreen(currentJob),
        );

      case editJobScreen:
        return MaterialPageRoute(
          builder: (context) => EditJobScreen(),
        );

      case activeJobScreen:
        final currentJob = settings.arguments as Job;
        return MaterialPageRoute(
          builder: (context) => ActiveJobScreen(currentJob),
        );

      case timesheetScreen:
        return MaterialPageRoute(
          builder: (context) => TimesheetScreen(),
        );

      case mapsGoogleScreen:
        return MaterialPageRoute(
          builder: (context) => MapsGoogleScreen(),
        );

      default:
        throw const FormatException('Route not found! Check routes again!');
    }
  }
}
