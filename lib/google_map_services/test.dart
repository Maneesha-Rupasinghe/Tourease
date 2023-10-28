
import 'location_service/location_service.dart';

Future<String> calculateTotalDistanceAndDuration(List<String> places) async {
  Map<String, String> distanceMap = {}; // Store distances
  Map<String, String> durationMap = {}; // Store durations
  int totalDistance = 0;
  int totalDuration = 0;

  for (var i = 0; i < places.length - 1; i++) {
    var directions =
        await LocationService().getDirections(places[i], places[i + 1]);

    distanceMap['${places[i]} to ${places[i + 1]}'] = directions['distance'];
    durationMap['${places[i]} to ${places[i + 1]}'] = directions['duration'];

    int distance = int.parse(directions['distance'].replaceAll(" km", ""));
    int duration = int.parse(directions['duration']);
    totalDistance += distance;
    totalDuration += duration;
  }

  return 'Total Distance: $totalDistance km\nTotal Duration: $totalDuration minutes';
}

void main() async {
  List<String> places = [
    "Colombo",
    "Kurunegala",
    "Anuradhapura",
    "Trincomalee",
    "Jaffna",
  ];

  String result = await calculateTotalDistanceAndDuration(places);

  print(result);
  
}
