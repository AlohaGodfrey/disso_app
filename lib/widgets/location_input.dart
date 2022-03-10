import 'package:flutter/material.dart';

import '../theme/palette.dart';

class LocationInput extends StatelessWidget {
  final String _previewImageUrl;
  const LocationInput(this._previewImageUrl, {Key? key}) : super(key: key);

  //uses location_service URL to generate a map
  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    //screen size optimizations
    bool isLargeScreen = deviceSize.width > Palette.deviceScreenThreshold;
    return Container(
      width: isLargeScreen ? deviceSize.width * 0.5 : double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey),
      ),
      child: Image.network(
        _previewImageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
      ),
    );
  }
}
