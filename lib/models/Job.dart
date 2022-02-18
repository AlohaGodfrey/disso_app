import 'package:flutter/material.dart';

import 'job_location.dart';

class Job with ChangeNotifier {
  final String id;
  final String title;
  final String postcode;
  final String description;
  final DateTime endDate;
  final PlaceLocation location;
  bool vehicleRequired;

  Job(
      {required this.id,
      required this.title,
      required this.description,
      required this.endDate,
      required this.postcode,
      this.location =
          const PlaceLocation(latitude: 37.419857, longitude: -122.078827),
      this.vehicleRequired = false});
}
