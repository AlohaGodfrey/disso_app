import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsView extends StatelessWidget {
  final CameraPosition initCameraPosition;
  final Function generateMapMarkers;
  final Completer<GoogleMapController> mapController;
  const MapsView(
      {required this.initCameraPosition,
      required this.generateMapMarkers,
      required this.mapController,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mapMarkers = generateMapMarkers();
    return Container(
      padding: const EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height * 0.49,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(136, 212, 212, 212),
              blurRadius: 2.0,
              spreadRadius: 0.0,
              offset: Offset(2.0, 2.0),
              // shadow direction: bottom right
            ),
          ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: GoogleMap(
            mapType: MapType.normal,
            //callback returned as Set<Marker>
            markers: mapMarkers,

            initialCameraPosition: initCameraPosition,
            onMapCreated: (GoogleMapController controller) {
              mapController.complete(controller);
            },
          ),
        ),
      ),
    );
  }
}
