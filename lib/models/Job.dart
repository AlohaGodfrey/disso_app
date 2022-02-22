import 'package:flutter/material.dart';

import 'job_location.dart';

enum LightConfig { twoWay, threeWay, fourWay }

class Job with ChangeNotifier {
  final String id;
  final String title;
  final String postcode;
  final String description;
  final DateTime endDate;
  final PlaceLocation location;
  //either car required or public transport.
  final bool vehicleRequired; //should be enum for later use
  final double payRate;
  final LightConfig lightConfig;

  Job(
      {required this.id,
      required this.title,
      required this.description,
      required this.endDate,
      required this.postcode,
      this.location =
          const PlaceLocation(latitude: 37.419857, longitude: -122.078827),
      this.vehicleRequired = false,
      this.payRate = 13.50,
      this.lightConfig = LightConfig.twoWay});
}
