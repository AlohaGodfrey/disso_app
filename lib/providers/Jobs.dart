import 'dart:convert';
import 'dart:async';

import 'package:disso_app/models/place_location.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; //bundle in http prefix

import '../models/http_exception.dart';
import '../helpers/firebase_service.dart';
import '../models/job_model.dart';

class Jobs with ChangeNotifier {
  List<Job> _jobItems = [];

  final String authToken;
  final String authUserId;

  Jobs(this._jobItems, {required this.authToken, required this.authUserId});

  //getter
  List<Job> get jobItems {
    return [..._jobItems];
  }

  void clearJobList() {
    _jobItems = [];
  }

  Job findById(String id) {
    // if (id == '') {
    //   return Job;
    // }

    return _jobItems.firstWhere((place) => place.id == id);
  }

  Future<void> foo(Job jobEntry) async {
    return;
  }

  Future<void> addJob(Job jobEntry) async {
    try {
      final url = firebaseUrl(authToken, '/job-list.json');
      final response = await http.post(
        url,
        body: json.encode({
          'title': jobEntry.title,
          'postcode': jobEntry.postcode,
          'description': jobEntry.description,
          'endDate': jobEntry.endDate.toIso8601String(),
          'payRate': jobEntry.payRate,
          'vehicleRequired': jobEntry.vehicleRequired.name,
          'lightConfig': jobEntry.lightConfig.name,
          'latcoord': jobEntry.location.latitude,
          'lngcoord': jobEntry.location.longitude
        }),
      );

      // print(json.decode(response.body));

      final newJob = Job(
          title: jobEntry.title,
          postcode: jobEntry.postcode,
          description: jobEntry.description,
          endDate: jobEntry.endDate,
          payRate: jobEntry.payRate,
          vehicleRequired: jobEntry.vehicleRequired,
          lightConfig: jobEntry.lightConfig,
          location: jobEntry.location,
          //assigns unique Id returned by the server
          id: json.decode(response.body)['name']);

      _jobItems.insert(0, newJob);
      // _items.insert(0, newProduct); //at the start of the list
      //^^^^important feature for later above^^^^^
      //add a new job to the top of the list or load the list
      //in reverse order

      notifyListeners();
    } catch (error) {
      // print(error);
      throw error;
    }
  }

  Future<void> updateJob(String id, Job newJob) async {
    final jobIndex = _jobItems.indexWhere((job) => job.id == id);
    if (jobIndex >= 0) {
      final url = firebaseUrl(authToken, '/job-list/$id.json');
      await http.patch(url,
          body: json.encode({
            'title': newJob.title,
            'postcode': newJob.postcode,
            'description': newJob.description,
            'endDate': newJob.endDate.toIso8601String(),
            'payRate': newJob.payRate,
            'vehicleRequired': newJob.vehicleRequired.name,
            'lightConfig': newJob.lightConfig.name,
            'latcoord': newJob.location.latitude,
            'lngcoord': newJob.location.longitude
          }));
      _jobItems[jobIndex] = newJob;
      notifyListeners();
    } else {
      //error handling code here.
      print('...');
    }
  }

  Future<void> deleteJob(String id) async {
    //---Optimistic Updating---
    //remove the item from the local list and database list,
    //however if the database deletion fails, it rollbacks the deleted item
    final existingJobIndex = _jobItems.indexWhere((job) => job.id == id);
    var existingJob = _jobItems[existingJobIndex];
    _jobItems.removeAt(existingJobIndex);
    notifyListeners();

    final url = firebaseUrl(authToken, '/job-list/$id.json');
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _jobItems.insert(existingJobIndex, existingJob);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    //if no error is thrown, removes job from memory
    existingJob = Job(
      id: DateTime.now().toString(),
      title: '',
      postcode: '',
      description: '',
      endDate: DateTime.now(),
    );
    //feeds all listeners with new data
    notifyListeners();
  }

  Future<void> fetchAndSetJobs() async {
    try {
      var url = firebaseUrl(
        authToken,
        '/job-list.json',
      );
      final response = await http.get(url);
      if (response.body == "null") {
        return;
      }
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        //when the lists are empty no data is parsed
        return;
      }
      final List<Job> loadedJobs = [];
      extractedData.forEach((jobId, jobData) {
        loadedJobs.add(
          Job(
            id: jobId,
            title: jobData['title'],
            postcode: jobData['postcode'],
            description: jobData['description'],
            payRate: jobData['payRate'],
            endDate: DateTime.parse(jobData['endDate']),
            vehicleRequired:
                retrieveVehicleRequirments(jobData['vehicleRequired']),
            lightConfig: retrieveLightConfig(jobData['lightConfig']),
            location: PlaceLocation(
              latitude: jobData['latcoord'],
              longitude: jobData['lngcoord'],
            ),
          ),
        );
      });

      _jobItems = loadedJobs.reversed.toList();
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  VehicleRequired retrieveVehicleRequirments(String transportMode) {
    switch (transportMode) {
      case 'anyTransport':
        return VehicleRequired.anyTransport;
      case 'carOnly':
        return VehicleRequired.carOnly;
      case 'noParking':
        return VehicleRequired.noParking;
      default:
        return VehicleRequired.anyTransport;
    }
  }

  LightConfig retrieveLightConfig(String lightSetup) {
    switch (lightSetup) {
      case 'twoWay':
        return LightConfig.twoWay;
      case 'threeWay':
        return LightConfig.threeWay;
      case 'fourWay':
        return LightConfig.fourWay;
      default:
        return LightConfig.twoWay;
    }
  }
}
