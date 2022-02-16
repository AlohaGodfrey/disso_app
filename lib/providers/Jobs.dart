import 'package:disso_app/providers/Job.dart';
import 'package:flutter/material.dart';

import 'Job.dart';

class Jobs with ChangeNotifier {
  final List<Job> _jobItems = [
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

  //getter
  List<Job> get jobItems {
    return [..._jobItems];
  }

  Job findById(String id) {
    return _jobItems.firstWhere((place) => place.id == id);
  }
}
