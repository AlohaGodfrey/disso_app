import 'dart:async';

import 'package:disso_app/widgets/show_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../helpers/location_service.dart';
import '../widgets/app_drawer.dart';
import '../widgets/profile_search_sliver.dart';

class MapsGoogleScreen extends StatefulWidget {
  const MapsGoogleScreen({Key? key}) : super(key: key);

  @override
  State<MapsGoogleScreen> createState() => MapsGoogleScreenState();
}

class MapsGoogleScreenState extends State<MapsGoogleScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final TextEditingController _searchController = TextEditingController();

  //maps camera controls
  Future<void> _goToCustomPlace(Map<String, dynamic> place) async {
    //gets place id
    final double lat = place['geometry']['location']['lat'];
    final double lng = place['geometry']['location']['lng'];
    final GoogleMapController controller = await _controller.future;

    //moves the maps viewport
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(lat, lng), zoom: 14)),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kTheRye));
  }

  Future<void> _goToTheBNU() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kUniCampus));
  }

  Future<void> _searchUpdateMap() async {
    var place = await LocationService.getPlace(_searchController.text);
    _goToCustomPlace(place);
  }

  static const CameraPosition _kTheRye = CameraPosition(
    target: LatLng(51.626288, -0.742899),
    zoom: 14.4746,
  );

  static const CameraPosition _kUniCampus = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(51.628082, -0.753216),
    // tilt: 59.440717697143555,
    zoom: 15,
  );

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  static const Marker _kUniCampusMarker = Marker(
      markerId: MarkerId('_kUniCampus'),
      infoWindow:
          InfoWindow(title: 'Bucks New University', snippet: 'A good worker'),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(51.628082, -0.753216));

  static final Marker _kTheRyeMarker = Marker(
      markerId: const MarkerId('_kTheRye'),
      infoWindow: const InfoWindow(title: 'The Rye Park'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      position: const LatLng(51.626288, -0.742899));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          const SliverAppBar(
            pinned: false,
            title: Text('Google Maps'),
          ),
          ProfileSearchSliver(
            isAdmin: true,
            searchController: _searchController,
            searchFunction: _searchUpdateMap,
            searchBarHint: "Enter a Location?",
            searchType: SearchType.viaSearchButton,
            helpDialog: HelpHintType.mapsGoogle,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  height: MediaQuery.of(context).size.height * 0.70,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          height: MediaQuery.of(context).size.height * 0.49,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
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
                                markers: {_kUniCampusMarker, _kTheRyeMarker},
                                initialCameraPosition: _kUniCampus,
                                onMapCreated: (GoogleMapController controller) {
                                  _controller.complete(controller);
                                },
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: MediaQuery.of(context).size.width * 0.9,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 5,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromARGB(136, 212, 212, 212),
                                  blurRadius: 2.0,
                                  spreadRadius: 0.0,
                                  offset: Offset(2.0,
                                      2.0), // shadow direction: bottom right
                                ),
                              ]),
                          child: ListView(
                              padding: const EdgeInsets.all(7),
                              children: [
                                ListTile(
                                  leading: const Icon(
                                    Icons.circle,
                                    color: Colors.green,
                                    size: 30,
                                  ),
                                  title: const Text('Worker 1'),
                                  subtitle: const Text('Location: The Rye'),
                                  onTap: () async {
                                    await _goToTheLake();
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(
                                    Icons.circle,
                                    color: Colors.green,
                                  ),
                                  title: const Text('Worker 2'),
                                  subtitle: const Text('Location: BNU Campus'),
                                  onTap: () async {
                                    await _goToTheBNU();
                                  },
                                )
                              ]),
                        ),
                      ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
