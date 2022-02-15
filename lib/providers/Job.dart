import 'package:flutter/material.dart';

class Job with ChangeNotifier {
  final String id;
  final String title;
  final String postcode;
  final String description;
  final DateTime endDate;
  bool vehicleRequired;

  Job(
      {required this.id,
      required this.title,
      required this.description,
      required this.endDate,
      required this.postcode,
      this.vehicleRequired = false});
}
