import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../helpers/location_service.dart';

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

  void getCurrentuserLocation() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    final locData = await location.getLocation();

    //all you need is latitute and longtitute for any location in the world
    //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    if (locData == null) {
      return;
    }

    print(locData);
  }

  @override
  Widget build(BuildContext context) {
    final mapMarkers = generateMapMarkers();
    getCurrentuserLocation();
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
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            mapToolbarEnabled: true,

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
