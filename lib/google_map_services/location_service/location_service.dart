import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class LocationService {
  final String key = 'AIzaSyCOEVConwXpasMo2r3BK3qZkPHHqPQQ1Qo';

  Future<String> getPlaceID(String input) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key';

    var response = await http.get(Uri.parse(url));

    var json = convert.jsonDecode(response.body);

    var placeID = json['candidates'][0]['place_id'] as String;

    return placeID;
  }

  Future<Map<String, dynamic>> getPlace(String input) async {
    final placeID = await getPlaceID(input);

    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeID&key=$key';

    var response = await http.get(Uri.parse(url));

    var json = convert.jsonDecode(response.body);

    var results = json['result'] as Map<String, dynamic>;

    return results;
  }

  Future<Map<String, dynamic>> getDirections(
      String origin, String destination) async {
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$key';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);

    // Check if the response status is OK
    if (json['status'] == 'OK') {
      var route = json['routes'][0];
      var leg = route['legs'][0];

      // Extracting duration in minutes
      var durationInSeconds = leg['duration']['value'];
      var durationInMinutes = (durationInSeconds / 60).ceil();

      var results = {
        'bounds_ne': route['bounds']['northeast'],
        'bounds_sw': route['bounds']['southwest'],
        'start_location': leg['start_location'],
        'end_location': leg['end_location'],
        'distance': leg['distance']['text'],
        'duration':
            durationInMinutes.toString(), // Store the duration in minutes
        'polyline': route['overview_polyline']['points'],
        'polyline_decoded': PolylinePoints()
            .decodePolyline(route['overview_polyline']['points']),
      };
      return results;
    } else {
      throw Exception('Failed to fetch directions');
    }
  }
}
