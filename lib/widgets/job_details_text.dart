import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; //format date

import '../models/job_model.dart';

Widget googleFontStyle(String text) {
  return Text(
    text,
    style: GoogleFonts.inter(
        fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey.shade800),
  );
}

Widget jobDetailPanel(Job currentJob) {
  return Container(
    height: 115,
    padding: const EdgeInsets.all(12),
    width: double.infinity,
    margin: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: Colors.white,
      boxShadow: const [
        BoxShadow(
          color: Color.fromARGB(136, 212, 212, 212),
          blurRadius: 2.0,
          spreadRadius: 0.0,
          offset: Offset(2.0, 2.0), // shadow direction: bottom right
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Job Details',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 5,
        ),
        Flexible(
          child: googleFontStyle('Contract ID: ${currentJob.id}'),
        ),
        Flexible(
          child: googleFontStyle('Configuration : ${currentJob.description}'),
        ),
        Flexible(
          child: googleFontStyle('Configuration : ${currentJob.postcode}'),
        ),
        Flexible(
          child: googleFontStyle(
              'Contract Expiry : ${DateFormat('dd/MM/yyyy hh:mm').format(currentJob.endDate)}'),
        ),
      ],
    ),
  );
}

Widget transportIconFinder(VehicleRequired transportMode) {
  switch (transportMode) {
    case VehicleRequired.anyTransport:
      return Row(children: const [
        Icon(Icons.drive_eta),
        Icon(Icons.directions_walk),
        Icon(Icons.train),
        Icon(Icons.bike_scooter),
      ]);
    case VehicleRequired.carOnly:
      return const Icon(Icons.drive_eta);
    case VehicleRequired.noParking:
      return Row(children: const [
        Icon(Icons.train),
        Icon(Icons.bike_scooter),
      ]);
  }
}

Widget transportInfo(VehicleRequired transportMode) {
  switch (transportMode) {
    case VehicleRequired.anyTransport:
      return googleFontStyle('Public Transport');
    case VehicleRequired.carOnly:
      return googleFontStyle('Vehicle Required');
    case VehicleRequired.noParking:
      return googleFontStyle('No Parking');
  }
}
