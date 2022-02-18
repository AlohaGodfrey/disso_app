import 'package:flutter/material.dart';

import '../models/job.dart';

class TimesheetItem {
  final String id;
  final String siteName;
  final DateTime date;
  final double hoursWorked;
  final double payRate;

  TimesheetItem(
      {required this.id,
      required this.siteName,
      required this.date,
      required this.hoursWorked,
      required this.payRate});
}

class Timesheet with ChangeNotifier {
  // final String userId;
  List<TimesheetItem> _timesheet = [
    TimesheetItem(
        id: 'x1',
        siteName: 'Little Portugal',
        date: DateTime.now(),
        hoursWorked: 12,
        payRate: 11.5),
    TimesheetItem(
        id: 'x2',
        siteName: 'Setllington',
        date: DateTime.now(),
        hoursWorked: 12,
        payRate: 13.5),
    TimesheetItem(
        id: 'x3',
        siteName: 'Finchley',
        date: DateTime.now(),
        hoursWorked: 12,
        payRate: 11.5),
    TimesheetItem(
        id: 'x4',
        siteName: 'Milton Keynes',
        date: DateTime.now(),
        hoursWorked: 12,
        payRate: 11.5),
    TimesheetItem(
        id: 'x5',
        siteName: 'Vicarige Lane',
        date: DateTime.now(),
        hoursWorked: 12,
        payRate: 11.5),
    TimesheetItem(
        id: 'x6',
        siteName: 'Kensington',
        date: DateTime.now(),
        hoursWorked: 12,
        payRate: 11.5),
    TimesheetItem(
        id: 'x6',
        siteName: 'Kensington',
        date: DateTime.now(),
        hoursWorked: 12,
        payRate: 11.5),
    TimesheetItem(
        id: 'x6',
        siteName: 'Kensington',
        date: DateTime.now(),
        hoursWorked: 12,
        payRate: 11.5),
  ];

  // Timesheet(this.userId, this._timesheet);

  List<TimesheetItem> get timesheet {
    return [..._timesheet];
  }

  void addJob(Job activeJob, double hoursWorked) {
    //updates timesheet adding the most recent job at
    //the top of the list
    _timesheet.insert(
      0,
      TimesheetItem(
          id: DateTime.now().toString(),
          siteName: activeJob.title,
          date: DateTime.now(),
          hoursWorked: hoursWorked,
          payRate: activeJob.payRate),
    );
    //updates all the listeners
    notifyListeners();
  }

  Future<void> fetchAndSetTimesheet() async {}

  Future<void> addJobX() async {}
}
