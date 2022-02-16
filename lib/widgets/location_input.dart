import 'package:flutter/material.dart';

// import 'package:location/location.dart'; //location data. see pub.dev docs
import 'package:google_maps_flutter/google_maps_flutter.dart'; //for LatLng

class LocationInput extends StatelessWidget {
  final String _previewImageUrl;
  LocationInput(this._previewImageUrl);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey),
      ),
      child: _previewImageUrl == null
          ? const Center(
              child: Text(
                'No Active Location',
                textAlign: TextAlign.center,
              ),
            )
          : Image.network(
              _previewImageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
    );
  }
}
