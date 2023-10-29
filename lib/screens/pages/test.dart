// import 'package:flutter/material.dart';
// import 'package:tourease/google_map_services/draw_path.dart';
// import 'package:tourease/google_map_services/get_distance_duration.dart';

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   final List<String> places = [
//     "Colombo",
//     "Kurunegala",
//     "Anuradhapura",
//     "Trincomalee",
//     "Jaffna"
//   ];
//   final DistanceAndDuration distanceDuration = DistanceAndDuration();

//   @override
//   void initState() {
//     super.initState();
//     // Call the calculateTotalDistanceAndDuration function
//     distanceDuration.calculateTotalDistanceAndDuration(places).then((_) {
//       setState(() {
//         // The distances and durations have been calculated.
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: "Distance Durations App",
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text("Distance Durations"),
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               if (distanceDuration.totalDistance != null)
//                 Text("Total Distance: ${distanceDuration.totalDistance} km"),
//               SizedBox(
//                 height: 10,
//               ),
//               if (distanceDuration.totalDuration != null)
//                 Text(
//                     "Total Duration: ${distanceDuration.totalDuration} minutes"),
//               //DrawPath(places: places),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
