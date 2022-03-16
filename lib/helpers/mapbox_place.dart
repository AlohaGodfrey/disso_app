import 'dart:convert' as convert; //json decoder
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class PlacesSearch {
  /// API Key of the MapBox.
  final String apiKey;

  /// Check the full list of [supported languages](https://docs.mapbox.com/api/search/#language-coverage) for the MapBox API
  final String? language;

  ///Limit results to one or more countries. Permitted values are ISO 3166 alpha 2 country codes separated by commas.
  ///
  /// Check the full list of [supported countries](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2) for the MapBox API
  final String? country;

  /// Specify the maximum number of results to return. The default is 5 and the maximum supported is 10.
  final int? limit;

  final String _url = 'https://api.mapbox.com/geocoding/v5/mapbox.places/';

  PlacesSearch({
    required this.apiKey,
    this.country,
    this.limit,
    this.language,
    // this.types,
  });

  String _createUrl(String queryText) {
    String finalUrl = '$_url${Uri.encodeFull(queryText)}.json?';
    finalUrl += 'access_token=$apiKey';

    if (country != null) {
      finalUrl += "&country=$country";
    }

    if (limit != null) {
      finalUrl += "&limit=$limit";
    }

    if (language != null) {
      finalUrl += "&language=$language";
    }

    return finalUrl;
  }

  Future<Map<String, dynamic>> getPlaces(
    String queryText, {
    Location? location,
  }) async {
    String url = _createUrl(queryText);
    final response = await http.get(Uri.parse(url));

    if (response.body.contains('message')) {
      throw Exception(convert.jsonDecode(response.body)['features']);
    }
    final extractedData =
        convert.json.decode(response.body) as Map<String, dynamic>;
    // print(extractedData['features'][0]['geometry']['coordinates']);
    return extractedData;
  }
}
