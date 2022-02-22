import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; //bundle in http prefix
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';
import '../helpers/firebase_url.dart';
import '../models/Job.dart';

class Jobs with ChangeNotifier {
  List<Job> _jobItems = [
    Job(
      id: 'p1',
      title: 'Islington',
      description: 'Two way lights',
      endDate: DateTime.now(),
      postcode: 'HP11 2et',
    ),
    Job(
      id: 'p2',
      title: 'Kingston',
      description: 'Two way lights',
      endDate: DateTime.now(),
      postcode: 'HP11 2et',
    ),
    Job(
      id: 'p3',
      title: 'Streatham',
      description: 'Two way lights',
      endDate: DateTime.now(),
      postcode: 'HP11 2et',
    ),
    Job(
      id: 'p4',
      title: 'Lewisham',
      description: 'Two way lights',
      endDate: DateTime.now(),
      postcode: 'HP11 2et',
    ),
    Job(
      id: 'p5',
      title: 'Caledonian',
      description: 'Two way lights',
      endDate: DateTime.now(),
      postcode: 'HP11 2et',
    ),
    Job(
      id: 'p6',
      title: 'Camden - Caledonian Road',
      description: 'Four way lights',
      endDate: DateTime.now(),
      postcode: 'HP11 2et',
    ),
  ];

  final String authToken;
  final String authUserId;

  Jobs(this._jobItems, {required this.authToken, required this.authUserId});

  //getter
  List<Job> get jobItems {
    return [..._jobItems];
  }

  Job findById(String id) {
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
          'vehicleRequired': jobEntry.vehicleRequired,
          'lightConfig': jobEntry.lightConfig.name,
        }),
      );

      print(json.decode(response.body));

      final newJob = Job(
          title: jobEntry.title,
          postcode: jobEntry.postcode,
          description: jobEntry.description,
          endDate: jobEntry.endDate,
          payRate: jobEntry.payRate,
          vehicleRequired: jobEntry.vehicleRequired,
          lightConfig: jobEntry.lightConfig,
          //assigns unique Id returned by the server
          id: json.decode(response.body)['name']);

      _jobItems.insert(0, newJob);
      // _items.insert(0, newProduct); //at the start of the list
      //^^^^important feature for later above^^^^^
      //add a new job to the top of the list or load the list
      //in reverse order

      notifyListeners();
    } catch (error) {
      print(error);
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
            'endDate': newJob.endDate,
            'payRate': newJob.payRate,
            'vehicleRequired': newJob.vehicleRequired,
            'lightConfig': newJob.lightConfig,
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
  }

  Future<void> fetchAndSetJobs() async {
    try {
      //builds the custom url location
      // String _customUrl = _dbUrl + '/products.json' + _authUrl;
      // final Uri _url = Uri.parse(_customUrl);

      var url = firebaseUrl(
        authToken,
        '/job-list.json',
      );
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        //when the lists are empty no data is parsed
        return;
      }
      // url = firebaseUrl(authToken, '/job-list.json');
      // final favoriteResponse = await http.get(url);
      // final favoriteData = json.decode(favoriteResponse.body);
      final List<Job> loadedJobs = [];
      extractedData.forEach((jobId, jobData) {
        loadedJobs.add(Job(
            id: jobId,
            title: jobData['title'],
            postcode: jobData['postcode'],
            description: jobData['description'],
            payRate: jobData['payRate'],
            endDate: DateTime.parse(jobData['endDate']),
            vehicleRequired: jobData['vehicleRequired']

            // isFavorite: prodData['isFavorite'],
            ));
      });
      _jobItems = loadedJobs;
      notifyListeners();
    } catch (error) {
      throw (error);
      print(error);
    }
  }
}
