import 'location_service/location_service.dart';

// List<String> places = [
//     "Colombo",
//     "Kurunegala",
//     "Anuradhapura",
//     "Trincomalee",
//     "jaffna"
//   ];

class DistanceAndDuration {
  Map<String, String> distanceMap = {}; // Store distances
  Map<String, String> durationMap = {}; // Store durations
  int totalDistance = 0;
  int totalDuration = 0;
  List<Future<void>> loadPlaceFutures = [];

  Future<void> calculateTotalDistanceAndDuration(List<String> places) async {
    totalDistance = 0;
    totalDuration = 0;
    // Create a list of Futures for all the _loadPlace calls
    for (var i = 0; i < places.length - 1; i++) {
      loadPlaceFutures.add(_loadPlace(places[i], places[i + 1]));
    }

    // Wait for all the asynchronous calls to complete
    await Future.wait(loadPlaceFutures);

    // All calls have completed, now you can access the totalDistance and totalDuration
    print(totalDistance);
    print(totalDuration);
  }

  Future<void> _loadPlace(String input1, String input2) async {
    var directions = await LocationService().getDirections(input1, input2);

    distanceMap['$input1 to $input2'] = directions['distance'];
    durationMap['$input1 to $input2'] = directions['duration'];

    int distance = int.parse(directions['distance'].replaceAll(" km", ""));
    int duration = int.parse(directions['duration']);
    totalDistance = totalDistance + distance;
    totalDuration = totalDuration + duration;
  }
}
