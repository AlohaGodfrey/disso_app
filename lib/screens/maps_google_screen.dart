import 'dart:async';

import 'package:disso_app/widgets/show_dialog.dart';
import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../providers/jobs_firebase.dart';
import '../models/job_model.dart';
import '../helpers/location_service.dart';
import '../widgets/app_drawer.dart';
import '../widgets/profile_search_sliver.dart';
import '../models/place_location.dart';

class MapsGoogleScreen extends StatefulWidget {
  const MapsGoogleScreen({Key? key}) : super(key: key);

  @override
  State<MapsGoogleScreen> createState() => MapsGoogleScreenState();
}

class MapsGoogleScreenState extends State<MapsGoogleScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final TextEditingController _searchController = TextEditingController();
  final initCameraPosition = const CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(51.628082, -0.753216),
      // tilt: 59.440717697143555,
      zoom: 14.4746);
  String? dropdownSelectedValue;

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

  void _goToJobCamera(String dropdownListJob, List<Job> jobList) {
    var jobLocation = {
      'geometry': {
        'location': {
          'lat': jobList
              .firstWhere((job) => job.title == dropdownListJob)
              .location
              .latitude,
          'lng': jobList
              .firstWhere((job) => job.title == dropdownListJob)
              .location
              .longitude
        }
      }
    };
    _goToCustomPlace(jobLocation);
  }

  Future<void> _searchUpdateMap() async {
    var place = await LocationService.getPlace(_searchController.text);
    _goToCustomPlace(place);
  }

  @override
  void dispose() {
    //free up memory by disposing controller
    _searchController.dispose();
    super.dispose();
  }

  Set<Marker> _returnJobListMarker(List<Job> jobList) {
    //adds a custom location marker for each job in joblist
    var marker = <Marker>[];
    for (var job in jobList) {
      marker.add(
        Marker(
            markerId: MarkerId('_k${job.title}'),
            infoWindow: InfoWindow(title: job.title, snippet: job.description),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            position: LatLng(job.location.latitude, job.location.longitude)),
      );
    }

    return {...marker};
  }

  @override
  Widget build(BuildContext context) {
    //uses Auth & Jobs Providers to retrieve relevant data
    final jobList = Provider.of<JobsFirebase>(context, listen: false).jobItems;
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
                          margin: const EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Visibility(
                                visible: jobList.isNotEmpty,
                                child: CustomDropdownButton2(
                                  hint: 'Select Job Site',
                                  value: dropdownSelectedValue,
                                  dropdownItems:
                                      jobList.map((job) => job.title).toList(),
                                  onChanged: (value) {
                                    //move camera postion to job
                                    setState(() {
                                      dropdownSelectedValue = value;

                                      _goToJobCamera(value as String, jobList);
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
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
                                markers: _returnJobListMarker(jobList),
                                initialCameraPosition: initCameraPosition,
                                onMapCreated: (GoogleMapController controller) {
                                  _controller.complete(controller);
                                },
                              ),
                            ),
                          ),
                        ),

                        // Container(
                        //   height: MediaQuery.of(context).size.height * 0.1,
                        //   width: MediaQuery.of(context).size.width * 0.9,
                        //   margin: const EdgeInsets.symmetric(
                        //     horizontal: 5,
                        //   ),
                        //   decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(16),
                        //       color: Colors.white,
                        //       boxShadow: const [
                        //         BoxShadow(
                        //           color: Color.fromARGB(136, 212, 212, 212),
                        //           blurRadius: 2.0,
                        //           spreadRadius: 0.0,
                        //           offset: Offset(2.0,
                        //               2.0), // shadow direction: bottom right
                        //         ),
                        //       ]),
                        //   child: ListView(
                        //       padding: const EdgeInsets.all(7),
                        //       children: [
                        //         ListTile(
                        //           leading: const Icon(
                        //             Icons.circle,
                        //             color: Colors.green,
                        //             size: 30,
                        //           ),
                        //           title: const Text('Worker 1'),
                        //           subtitle: const Text('Location: The Rye'),
                        //           onTap: () async {
                        //             await _goToTheLake();
                        //           },
                        //         ),
                        //         ListTile(
                        //           leading: const Icon(
                        //             Icons.circle,
                        //             color: Colors.green,
                        //           ),
                        //           title: const Text('Worker 2'),
                        //           subtitle: const Text('Location: BNU Campus'),
                        //           onTap: () async {
                        //             await _goToTheBNU();
                        //           },
                        //         )
                        //       ]),
                        // ),
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
