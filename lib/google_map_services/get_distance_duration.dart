// import 'location_service/location_service.dart';

// class DistanceAndDuration {
//   Map<String, String> distanceMap = {}; // Store distances
//   Map<String, String> durationMap = {}; // Store durations
//   int totalDistance = 0;
//   int totalDuration = 0;
//   List<Future<void>> loadPlaceFutures = [];

//   Future<String> calculateTotalDistanceAndDuration(List<String> places) async {
//     // Create a list of Futures for all the _loadPlace calls

//     for (var i = 0; i < places.length - 1; i++) {
//       loadPlaceFutures.add(_loadPlace(places[i], places[i + 1]));
//     }

//     // Wait for all the asynchronous calls to complete
//     await Future.wait(loadPlaceFutures);

//     // Calculate totalDuration in hours and minutes
//     int totalMinutes = totalDuration;
//     int hours = totalMinutes ~/ 60;
//     int minutes = totalMinutes % 60;

//     return 'Total Distance: $totalDistance km\nTotal Duration: $hours hours and $minutes minutes';
//   }

//   Future<void> _loadPlace(String input1, String input2) async {
//     var directions = await LocationService().getDirections(input1, input2);

//     distanceMap['$input1 to $input2'] = directions['distance'];
//     durationMap['$input1 to $input2'] = directions['duration'];

//     int distance = int.parse(directions['distance'].replaceAll(" km", ""));
//     int duration = int.parse(directions['duration']);
//     totalDistance = totalDistance + distance;
//     totalDuration = totalDuration + duration;
//   }
// }
