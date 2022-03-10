import 'dart:convert' as convert; //json decoder

import 'package:location/location.dart';
import 'package:http/http.dart' as http;
// import 'package:universal_html/html.dart';
// import 'package:universal_html/js.dart' as js;
// import 'package:google_place/google_place.dart';
import 'package:flutter/foundation.dart';

import '../models/http_exception.dart'; //custom exception
import 'package:mapbox_search/mapbox_search.dart ' as mpbx;

//API KEYS
const GOOGLE_API_KEY = 'AIzaSyBVy5E8sxIs9cuhC8_br2tvvWrAFugAV_w';
const MAPBOX_API_KEY =
    'pk.eyJ1IjoibXJhbG9oYWdvZGZyZXkiLCJhIjoiY2wwaW0wcnMwMDMyeDNjb2c4cG4yazh1YSJ9.rFAxExobut6iLyw42Aee6A';

class LocationService {
  //returns a map image with custom markers
  //it is possible to add multiple markers on a page
  static String generateLocationPreviewImage(
      {required double latitute, required double longitude}) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitute,$longitude&zoom=14&size=800x400&maptype=roadmap&markers=color:red%7Clabel:C%7C$latitute,$longitude&key=$GOOGLE_API_KEY';
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
    var plainUrl = Uri.parse(url);
    var response = await http.get(Uri.parse(url));
    print(response);
    var json = convert.jsonDecode(response.body);

    if (json['status'] == 'ZERO_RESULTS') {
      throw HttpException('Invalid Postcode');
    }
    var placeId = json['candidates'][0]['place_id'] as String;

    return placeId;
  }

  static Future<Map<String, dynamic>> getPlace(String input) async {
    Map<String, dynamic> result;
    if (kIsWeb) {
      //runs api for the web (MapBox) uses a different api due to the
      //CORS blocking on web local host using standard sdk
      result = await getWebPlaceId(input);
    } else {
      //runs api for mobile (google)
      final placeId = await getPlaceId(input);
      final String url =
          'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$GOOGLE_API_KEY';

      var response = await http.get(Uri.parse(url));
      var json = convert.jsonDecode(response.body);
      result = json['result'] as Map<String, dynamic>;
    }
    return result;
  }

  //web
  static Future<Map<String, dynamic>> getWebPlaceId(String input) async {
    //uses the mapbox forward geocoding api to get latlng from text query
    Map<String, dynamic> nomalizedResponse;

    var placesSearch = mpbx.PlacesSearch(
      apiKey: MAPBOX_API_KEY,
      limit: 5,
    );

    try {
      //feteches the data
      final response = await placesSearch.getPlaces(input);

      final lat = response![0].geometry!.coordinates![1];
      final lng = response[0].geometry!.coordinates![0];
      nomalizedResponse = {
        'geometry': {
          'location': {
            'lat': lat,
            'lng': lng,
          }
        }
      };
    } catch (error) {
      //if error the coords default to Trafalgar Square
      nomalizedResponse = {
        'geometry': {
          'location': {
            'lat': 51.507321899999994,
            'lng': -0.12764739999999997,
          }
        }
      };
    }

    return nomalizedResponse;
  }

  static Future<void> getCurrentuserLocation() async {
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
}
