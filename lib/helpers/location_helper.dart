import 'dart:convert'; //json decoder

import 'package:http/http.dart' as http;
// import 'package:location/location.dart'; //http request

const GOOGLE_API_KEY = 'AIzaSyCpse1vOgkUBCBr4zuzRx0jbROlGV-ymME';

class LocationHelper {
  //returns a map image with custom markers
  //it is possible to add multiple markers on a page
  static String generateLocationPreviewImage(
      {required double latitute, required double longitude}) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitute,$longitude&zoom=17&size=600x300&maptype=roadmap&markers=color:red%7Clabel:C%7C$latitute,$longitude&key=$GOOGLE_API_KEY';
  }

  //
  //we can use reverse geocoding to get human readable address from LatLng coords
  //include in disso
  static Future<String> getPlaceAddress(double lat, double lng) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$GOOGLE_API_KEY';

    final response = await http.get(Uri.parse(url));
    return json.decode(response.body)['results'][0]['formatted_address'];
  }
}
