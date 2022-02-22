import 'dart:convert'; //converts data into json

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; //allows web server communication

import '../models/job_model.dart';
import '../helpers/firebase_url.dart'; //custom made for Url/Uri Building

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
  final String authToken;
  final String userId;
  List<TimesheetItem> _timesheet = [];

  Timesheet(this.authToken, this.userId, this._timesheet);

  // List<TimesheetItem> _timesheet = [
  // TimesheetItem(
  //     id: 'x1',
  //     siteName: 'Little Portugal',
  //     date: DateTime.now(),
  //     hoursWorked: 12,
  //     payRate: 11.5),
  // TimesheetItem(
  //     id: 'x2',
  //     siteName: 'Setllington',
  //     date: DateTime.now(),
  //     hoursWorked: 12,
  //     payRate: 13.5),
  // TimesheetItem(
  //     id: 'x3',
  //     siteName: 'Finchley',
  //     date: DateTime.now(),
  //     hoursWorked: 12,
  //     payRate: 11.5),
  // TimesheetItem(
  //     id: 'x4',
  //     siteName: 'Milton Keynes',
  //     date: DateTime.now(),
  //     hoursWorked: 12,
  //     payRate: 11.5),
  // TimesheetItem(
  //     id: 'x5',
  //     siteName: 'Vicarige Lane',
  //     date: DateTime.now(),
  //     hoursWorked: 12,
  //     payRate: 11.5),
  // TimesheetItem(
  //     id: 'x6',
  //     siteName: 'Kensington',
  //     date: DateTime.now(),
  //     hoursWorked: 12,
  //     payRate: 11.5),
  // TimesheetItem(
  //     id: 'x6',
  //     siteName: 'Kensington',
  //     date: DateTime.now(),
  //     hoursWorked: 12,
  //     payRate: 11.5),
  // TimesheetItem(
  //     id: 'x6',
  //     siteName: 'Kensington',
  //     date: DateTime.now(),
  //     hoursWorked: 12,
  //     payRate: 11.5),
  // ];

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

  Future<void> fetchAndSetTimesheet() async {
    final url = firebaseUrl(authToken, '/timesheet/$userId.json');
    final response = await http.get(url);
    final List<TimesheetItem> loadedTimesheetList = [];
    final rawBody = json.decode(response.body);
    try {
      if (rawBody == null) {
        //when the lists are empty no data is parsed
        // throw HttpException('No Order History');
        return;
      }
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      extractedData.forEach((timesheetId, timesheetData) {
        loadedTimesheetList.add(
          TimesheetItem(
            id: timesheetId,
            siteName: timesheetData['siteName'],
            date: DateTime.parse(timesheetData['date']),
            payRate: timesheetData['payRate'],
            hoursWorked: timesheetData['hoursWorked'],
          ),
        );
      });

      _timesheet = loadedTimesheetList.reversed.toList();
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addJobX(Job activeJob, double hoursWorked) async {
    final timestamp = DateTime.now();
    final url = firebaseUrl(authToken, '/timesheet/$userId.json');

    final response = await http.post(
      url,
      body: json.encode({
        'siteName': activeJob.title,
        'date': timestamp.toIso8601String(),
        'hoursWorked': hoursWorked,
        'payRate': activeJob.payRate
      }),
    );
    _timesheet.insert(
      0,
      TimesheetItem(
          id: json.decode(response.body)['name'],
          siteName: activeJob.title,
          date: timestamp,
          hoursWorked: hoursWorked,
          payRate: activeJob.payRate),
    );
    notifyListeners();
  }
}
