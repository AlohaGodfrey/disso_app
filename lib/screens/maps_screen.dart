import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../routes/routes.dart';
import '../models/job_model.dart';
import '../helpers/location_service.dart';
import '../providers/jobs_firebase.dart';
import '../widgets/show_dialog.dart';
import '../widgets/app_drawer.dart';
import '../widgets/maps_card.dart';
import '../widgets/profile_search_sliver.dart';

import '../screens/list_job_screen.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({Key? key}) : super(key: key);

  @override
  State<MapsScreen> createState() => MapsScreenState();
}

class MapsScreenState extends State<MapsScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final TextEditingController _searchController = TextEditingController();
  var _isLoading = true;
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

//maps camera controls
  Future<void> _goToJobPlace(Map<String, dynamic> place) async {
    //gets place id
    final double lat = place['geometry']['location']['lat'];
    final double lng = place['geometry']['location']['lng'];
    final GoogleMapController controller = await _controller.future;

    //retrieves markerID
    final String markerId = place['MarkerId'];
    controller.showMarkerInfoWindow(MarkerId(markerId));

    //moves the maps viewport
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(lat, lng), zoom: 14)),
    );
  }

  //creates a map of job location and markerId from joblist
  void _normalizeJobData(String dropdownListJob, List<Job> jobList) {
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
      },
      'MarkerId':
          '_k${jobList.firstWhere((job) => job.title == dropdownListJob).title}',
    };
    _goToJobPlace(jobLocation);
  }

  //used to input custom location using the search profile sliver
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

  //used to autorefresh page once and item is removed from jobs provider
  Future<void> refreshPage() async {
    Provider.of<JobsFirebase>(context, listen: false).clearJobList();
    await Provider.of<JobsFirebase>(context, listen: false).fetchAndSetJobs();
  }

  //creates a set of markers from the timesheet data
  Set<Marker> _returnJobListMarker() {
    final jobList = Provider.of<JobsFirebase>(context, listen: false).jobItems;
    //adds a custom location marker for each job in joblist
    var marker = <Marker>[];
    for (var job in jobList) {
      marker.add(
        Marker(
            markerId: MarkerId('_k${job.title}'),
            infoWindow: InfoWindow(
                onTap: () {
                  Navigator.of(context).pushNamed(RouteManager.detailJobScreen,
                      arguments: {'jobID': job, 'refreshJobList': refreshPage});
                },
                title: '${job.title} \n${job.postcode} ',
                snippet: job.description),
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
            title: Text('Map Overview'),
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
                  // child: const WindowsGoogleMaps(),
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

                                      _normalizeJobData(
                                          value as String, jobList);
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        //dynamically chooses between web/mobile
                        MapsView(
                            initCameraPosition: initCameraPosition,
                            generateMapMarkers: _returnJobListMarker,
                            mapController: _controller),
                      ]),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
