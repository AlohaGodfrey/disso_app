import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_flutter_web/google_maps_flutter_web.dart';

class MapsWeb extends StatefulWidget {
  const MapsWeb({Key? key}) : super(key: key);

  @override
  State<MapsWeb> createState() => _MapsWebState();
}

class _MapsWebState extends State<MapsWeb> {
  late GoogleMapController _mapController;
  List<Marker> _markers = [];
  bool showmaps = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _markers.add(Marker(
      markerId: MarkerId('myLocation'),
      position: LatLng(59.958680, 11.010630),
    ));
    if (_markers.isNotEmpty) {
      setState(() {
        showmaps = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: showmaps
          ? Container(
              height: 300,
              width: 800,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(12)),
              child: GoogleMap(
                onMapCreated: (controller) {
                  setState(() {
                    _mapController = controller;
                  });
                },
                markers: Set<Marker>.of(_markers),
                mapType: MapType.normal,
                initialCameraPosition: const CameraPosition(
                  target: LatLng(59.948680, 11.010630),
                  zoom: 13,
                ),
              ),
            )
          : CircularProgressIndicator(
              color: Colors.amber,
            ),
    );
  }
}
