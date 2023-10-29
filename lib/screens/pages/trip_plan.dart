import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tourease/google_map_services/location_service/location_service.dart';
import 'package:tourease/screens/pages/userProfile.dart';
import 'package:tourease/screens/pages/weather_util.dart';
import 'package:tourease/google_map_services/draw_path.dart';
import 'package:tourease/google_map_services/get_distance_duration.dart';
import 'package:intl/intl.dart';
import 'package:tourease/google_map_services/test.dart';

class tripPlan extends StatefulWidget {
  const tripPlan({Key? key}) : super(key: key);

  @override
  State<tripPlan> createState() => _tripPlanState();
}

class _tripPlanState extends State<tripPlan> {
  List<List<double>> distance = [
    [1.0, 2.0],
    [3.0, 4.0],
  ];
  //DistanceAndDuration distanceAndDuration = DistanceAndDuration();
  List<String> destination = [];
  List<List<String>> _result = [];
  late DateTime fromDate = DateTime.now();
  late DateTime toDate = DateTime.now();
  double tappedIconSize = 40;
  List<String> localElements = [];

  String? totalDistanceAndDuration;
  final TextEditingController startCityController = TextEditingController();
  final TextEditingController endCityController = TextEditingController();

  final DistanceAndDuration distanceDuration = DistanceAndDuration();

  Future<void> _selectDate1(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2025),
    );

    if (picked != null && picked != fromDate) {
      setState(() {
        fromDate = picked;
      });
    }
  }

  Future<void> _selectDate2(BuildContext context) async {
    final DateTime? picked2 = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2025),
    );

    if (picked2 != null && picked2 != toDate) {
      setState(() {
        toDate = picked2;
      });
    }
  }

  Future<void> sendMatricesToCloudFunction(
      List<List<double>> distance, List<String> destination) async {
    const url =
        'https://us-central1-centered-inn-400015.cloudfunctions.net/find_all_path';
    final data = {
      'destination': destination,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      setState(() {
        _result = (responseData['possible_paths'] as List)
            .map((path) => (path as List).cast<String>())
            .toList();
        print("Send successful");
      });
    } else {
      print("Error in sending destinations");
    }
  }

  Future<List<String>> fetchCityNamesFromFirestore(String userUid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference usersCollection = firestore.collection('users');

    try {
      DocumentSnapshot userDoc = await usersCollection.doc(userUid).get();
      if (userDoc.exists) {
        final dynamic userData = userDoc.data();

        if (userData != null) {
          final selectedCitiesData = userData['selected_cities'];

          if (selectedCitiesData is List) {
            List<String> cities =
                selectedCitiesData.map((city) => city.toString()).toList();
            destination.addAll(cities);
            return cities;
          }
        }
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  String? getCurrentUserId() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return null;
    }
  }

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

  void _showEnlargedImage(String iconId) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Image.network(
            'https://openweathermap.org/img/wn/$iconId.png',
            width: 300,
            height: 300,
          ),
        );
      },
    );
  }

  Future<void> saveListToFirestore(String planName, List<String> myList) async {
    try {
      // Get the current user
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // User is not signed in
        return;
      }

      // Reference to the Firestore instance
      final firestore = FirebaseFirestore.instance;

      // Reference to the user's document
      final userDocument = firestore.collection('users').doc(user.uid);

      // Reference to the user_plans subcollection
      final userPlansCollection = userDocument.collection('user_plans');

      // Set the list with a custom document ID (planName)
      await userPlansCollection.doc(planName).set({
        'your_list_field_name': myList,
      });

      // You can handle success or display a message here
    } catch (e) {
      // Handle errors
      print('Error saving list to Firestore: $e');
    }
  }

  Future<void> clearSelectedCities() async {
    try {
      // Get the current user
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // User is not signed in
        return;
      }

      // Reference to the Firestore instance
      final firestore = FirebaseFirestore.instance;

      // Reference to the user's document
      final userDocument = firestore.collection('users').doc(user.uid);

      // Update the selected_cities field with an empty list
      await userDocument.update({
        'selected_cities': FieldValue.arrayRemove([]),
      });

      // You can handle success or display a message here
      print("clera");
    } catch (e) {
      // Handle errors
      print('Error clearing selected_cities in Firestore: $e');
    }
  }

  Future<String?> _getNameFromUser(BuildContext context) async {
    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController nameController = TextEditingController();
        return AlertDialog(
          title: Text('Enter a name for your plan'),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(hintText: 'Plan Name'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Save'),
              onPressed: () {
                Navigator.of(context).pop(nameController.text);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    // Retrieve city names from Firestore and populate the destination list
    final String? userUid = getCurrentUserId();
    if (userUid != null) {
      fetchCityNamesFromFirestore(userUid).then((cities) {
        setState(() {
          destination = cities;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 140),
                        child: Text("Trip Plan"),
                      ),
                      const SizedBox(
                        width: 90,
                      ),
                      IconButton(
                        icon: const Icon(Icons.person_3_outlined),
                        iconSize: 30,
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return const EditProfilePage();
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: Text("Duration"),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 80, left: 50),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () => _selectDate1(context),
                                child: const Text('Start Date'),
                              ),
                              TextButton(
                                onPressed: () => _selectDate2(context),
                                child: const Text('End Date'),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Row(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 40, right: 30),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10),
                                                child: Text(
                                                  fromDate != null
                                                      ? '${DateFormat('MMMM dd, yyyy').format(fromDate)}'
                                                      : 'Select a Date',
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 68,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10),
                                                child: Text(
                                                  toDate != null
                                                      ? '${DateFormat('MMMM dd, yyyy').format(toDate)}'
                                                      : 'Select a Date',
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),

                SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Destinations',
                                style: TextStyle(
                                    // Add your text style here, e.g., fontSize, fontWeight, etc.
                                    ),
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: (destination.length / 3).ceil(),
                              itemBuilder: (BuildContext context, int index) {
                                final startIndex = index * 3;
                                final endIndex =
                                    (startIndex + 3 < destination.length)
                                        ? startIndex + 3
                                        : destination.length;
                                final rowCities =
                                    destination.sublist(startIndex, endIndex);
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: rowCities.map((city) {
                                    return Expanded(
                                      child: ListTile(
                                        title: Text(city),
                                      ),
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                          ],
                        ),
                      )),
                ),
                // Start city input field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: startCityController,
                    decoration: InputDecoration(
                      labelText: 'From Where are you starting',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
// End city input field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: endCityController,
                    decoration: InputDecoration(
                      labelText: 'what is your destination',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    String startCity = startCityController.text;
                    String endCity = endCityController.text;

                    if (startCity.isEmpty || endCity.isEmpty) {
                      return;
                    }

                    // Update the destination list with start and end cities.
                    if (destination.isNotEmpty) {
                      destination.insert(
                          0, startCity); // Add start city to the front
                      destination.add(endCity); // Add end city to the back
                    }
                    print(destination);
                    sendMatricesToCloudFunction(distance, destination);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue, // Background color of the button
                    onPrimary: Colors.white, // Text color
                    padding: const EdgeInsets.all(
                        16.0), // Padding around the button's content
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Rounded corners
                      side:
                          const BorderSide(color: Colors.blue), // Border color
                    ),
                  ),
                  child: const Text(
                    'Show possible paths',
                    style: TextStyle(
                      fontSize: 18.0, // Text size
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // Display the result as a list (matrix)
                // if (_result.isNotEmpty) // Check if the result is not empty
                //   Column(
                //     children: _result.map((row) {
                //       return Row(
                //         children: row.map((element) {
                //           return Padding(
                //             padding: const EdgeInsets.all(8.0),
                //             child: Text(element),
                //           );
                //         }).toList(),
                //       );
                //     }).toList(),
                //   ),

                // SizedBox(
                //   height: 400,
                //   child: PageView(
                //     scrollDirection: Axis.horizontal,
                //     children: _result.map((subList) {
                //       return Container(
                //         decoration: BoxDecoration(
                //           border: Border.all(color: Colors.black),
                //         ),
                //         padding: EdgeInsets.all(8.0),
                //         margin: EdgeInsets.symmetric(horizontal: 8.0),
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: subList.map((element) {
                //             return Padding(
                //               padding: const EdgeInsets.all(25.0),
                //               child: Align(
                //                 alignment: Alignment.centerLeft,
                //                 child: Text(element),
                //               ),
                //             );
                //           }).toList(),
                //         ),
                //       );
                //     }).toList(),
                //   ),
                // ),

                SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: PageView(
                      scrollDirection: Axis.horizontal,
                      children: _result.map((subList) {
                        // Create a local list to store elements from subList
                        localElements
                            .clear(); // Clear the list for each subList

                        return Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 189, 218, 190),
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ListView(
                            // Wrap the content in a ListView
                            shrinkWrap:
                                true, // Ensures that the ListView takes up as little space as possible
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: List.generate(6, (index) {
                                      final currentDate = DateTime.now();
                                      final nextDate = currentDate
                                          .add(Duration(days: index));
                                      final formattedDate =
                                          "${nextDate.day.toString().padLeft(2, '0')}/${nextDate.month.toString().padLeft(2, '0')}";
                                      return Container(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(formattedDate),
                                      );
                                    }),
                                  ),
                                  ...subList.map((element) {
                                    localElements.add(element);

                                    return FutureBuilder<List<String>>(
                                      future:
                                          WeatherUtil.getWeatherData(element),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Text(
                                              "Fetching weather data for $element...");
                                        } else if (snapshot.hasError) {
                                          return Text(
                                              "Error fetching weather data for $element: ${snapshot.error}");
                                        } else if (snapshot.hasData) {
                                          final city = element;
                                          final iconIds = snapshot.data!;

                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(city),
                                              const SizedBox(height: 10),
                                              Row(
                                                children: iconIds.map((iconId) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            9.5),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return Center(
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child: Image
                                                                    .network(
                                                                  'https://openweathermap.org/img/wn/$iconId.png',
                                                                  width: 900,
                                                                  height: 900,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child: Image.network(
                                                        'https://openweathermap.org/img/wn/$iconId.png',
                                                        width: 40,
                                                        height: 40,
                                                        errorBuilder: (context,
                                                            error, stackTrace) {
                                                          return const Icon(
                                                              Icons.error);
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ],
                                          );
                                        } else {
                                          return Text(
                                              "No weather data available for $element");
                                        }
                                      },
                                    );
                                  }),
                                ],
                              ),
                              // FutureBuilder<String>(
                              //   future: calculateTotalDistanceAndDuration(
                              //       localElements),
                              //   builder: (context, snapshot) {
                              //     if (snapshot.connectionState ==
                              //         ConnectionState.done) {
                              //       if (snapshot.hasData) {
                              //         //print(localElements);
                              //         return Text(snapshot.data!);
                              //       } else if (snapshot.hasError) {
                              //         return Text('Error: ${snapshot.error}');
                              //       }
                              //     }
                              //     return const CircularProgressIndicator(); // Or some other loading indicator
                              //   },
                              // ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return DrawPath(places: localElements);
                                    }),
                                  );
                                },
                                child: const Text('Draw Path'),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  final planName =
                                      await _getNameFromUser(context);
                                  if (planName != null) {
                                    // Use planName to save the list in Firestore
                                    final myList = [
                                      'item1',
                                      'item2'
                                    ]; // Replace with your list
                                    saveListToFirestore(
                                        planName, localElements);
                                  }
                                  await clearSelectedCities();
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors
                                      .blue, // Background color of the button
                                  onPrimary: Colors.white, // Text color
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical:
                                          12.0), // Padding around the button's content
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10.0), // Rounded corners
                                  ),
                                ),
                                child: Text(
                                  'Save Your Plan',
                                  style: TextStyle(
                                    fontSize: 18.0, // Text size
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
