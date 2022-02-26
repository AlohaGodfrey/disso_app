import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../helpers/location_service.dart';

class MapsGoogleScreen extends StatefulWidget {
  @override
  State<MapsGoogleScreen> createState() => MapsGoogleScreenState();
}

class MapsGoogleScreenState extends State<MapsGoogleScreen> {
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController _searchController = TextEditingController();

  // static const CameraPosition _kGooglePlex = CameraPosition(
  //   target: LatLng(37.42796133580664, -122.085749655962),
  //   zoom: 14.4746,
  // );

  // static const CameraPosition _kLake = CameraPosition(
  //     bearing: 192.8334901395799,
  //     target: LatLng(37.43296265331129, -122.08832357078792),
  //     // tilt: 59.440717697143555,
  //     zoom: 19.151926040649414);

  static const CameraPosition _kTheRye = CameraPosition(
    target: LatLng(51.626288, -0.742899),
    zoom: 14.4746,
  );

  static const CameraPosition _kUniCampus = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(51.628082, -0.753216),
      // tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  static final Marker _kUniCampusMarker = Marker(
      markerId: MarkerId('_kUniCampus'),
      infoWindow:
          InfoWindow(title: 'Bucks New University', snippet: 'A good worker'),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(51.628082, -0.753216));

  static final Marker _kTheRyeMarker = Marker(
      markerId: MarkerId('_kTheRye'),
      infoWindow: InfoWindow(title: 'The Rye Park'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      position: LatLng(51.626288, -0.742899));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(children: [
          Row(
            children: [
              Expanded(
                  child: TextFormField(
                controller: _searchController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(hintText: 'Search by City'),
                onChanged: (value) {
                  print(value);
                },
              )),
              IconButton(
                  onPressed: () async {
                    var place =
                        await LocationService.getPlace(_searchController.text);
                    _goToCustomPlace(place);
                  },
                  icon: Icon(Icons.search))
            ],
          ),
          Expanded(
            child: GoogleMap(
              mapType: MapType.terrain,
              markers: {_kUniCampusMarker, _kTheRyeMarker},
              initialCameraPosition: _kUniCampus,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
        ]),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToTheLake,
      //   label: Text('To the lake!'),
      //   icon: Icon(Icons.directions_boat),
      // ),
    );
  }

  Future<void> _goToCustomPlace(Map<String, dynamic> place) async {
    //gets place id
    final double lat = place['geometry']['location']['lat'];
    final double lng = place['geometry']['location']['lng'];
    final GoogleMapController controller = await _controller.future;

    //moves the maps viewport
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(lat, lng), zoom: 15)),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kTheRye));
  }
}
