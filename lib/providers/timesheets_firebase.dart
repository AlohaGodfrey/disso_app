import 'dart:convert'; //converts data into json
import 'dart:math'; //used for calculating timesheets hours

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; //allows web server communication

import '../models/job_model.dart';
import '../models/timesheet_model.dart';
import '../helpers/firebase_service.dart'; //custom made for Url/Uri Building

class TimesheetsFirebase with ChangeNotifier {
  final String authToken;
  final String userId;
  List<TimesheetItem> _timesheet = [];

  TimesheetsFirebase(this.authToken, this.userId, this._timesheet);

  //timesheet getter
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
        loadedTimesheetList.add(TimesheetItem(
          id: timesheetId,
          siteName: timesheetData['siteName'],
          date: DateTime.parse(timesheetData['date']),
          payRate: timesheetData['payRate'],
          hoursWorked: double.parse(timesheetData['hoursWorked'].toString()),
        ));
      });

      _timesheet = loadedTimesheetList.reversed.toList();
      notifyListeners();
    } catch (error) {
      // print(error);
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

  //returns double rounded to places exponent
  static double roundDouble(double value, int places) {
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  static double calculateTimeWorked(String clockElapsedTime) {
    //remove colon from hh:mm:ss and store time in list<String>[h,m,s]
    final List<String> result = clockElapsedTime.split(RegExp(r':+'));
    //converts List<String> to formatted double
    final timesheetHours = double.parse(result[0]);
    final timesheetMinutes = double.parse(result[1]) / 60;
    //final time value must be rounded to two decimal place
    return roundDouble((timesheetHours + timesheetMinutes), 2);
  }
}
