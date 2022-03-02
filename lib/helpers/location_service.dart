import 'dart:convert' as convert; //json decoder
import 'package:http/http.dart' as http;

const GOOGLE_API_KEY = 'AIzaSyCpse1vOgkUBCBr4zuzRx0jbROlGV-ymME';

class LocationService {
  //returns a map image with custom markers
  //it is possible to add multiple markers on a page
  static String generateLocationPreviewImage(
      {required double latitute, required double longitude}) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitute,$longitude&zoom=17&size=600x300&maptype=roadmap&markers=color:red%7Clabel:C%7C$latitute,$longitude&key=$GOOGLE_API_KEY';
  }

  //we can use reverse geocoding to get human readable address from LatLng coords
  static Future<String> getPlaceAddress(double lat, double lng) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$GOOGLE_API_KEY';

    final response = await http.get(Uri.parse(url));
    return convert.json.decode(response.body)['results'][0]
        ['formatted_address'];
  }

  //private function takes a user location text input and returns geographical place id
  static Future<String> getPlaceId(String input) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$GOOGLE_API_KEY';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var placeId = json['candidates'][0]['place_id'] as String;

    return placeId;
  }

  static Future<Map<String, dynamic>> getPlace(String input) async {
    final placeId = await getPlaceId(input);
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$GOOGLE_API_KEY';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var results = json['result'] as Map<String, dynamic>;
    // print(results);

    return results;
  }
}
