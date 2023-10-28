import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tourease/screens/pages/weather_util.dart';
import 'package:tourease/google_map_services/get_distance_duration.dart';
import 'package:tourease/google_map_services/draw_path.dart';

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
  List<String> destination = [];
  List<List<String>> _result = [];
  late DateTime fromDate = DateTime.now();
  late DateTime toDate = DateTime.now();

  final distanceDuration = DistanceAndDuration();

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
          padding: EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextButton(
                  onPressed: () => _selectDate1(context),
                  child: Text('Select Date'),
                ),
                Text(
                  fromDate != null
                      ? 'Selected Date: ${fromDate.toLocal()}'
                      : 'Select a Date',
                ),
                TextButton(
                  onPressed: () => _selectDate2(context),
                  child: Text('Select Date'),
                ),
                Text(
                  toDate != null
                      ? 'Selected Date: ${toDate.toLocal()}'
                      : 'Select a Date',
                ),
                SingleChildScrollView(
                  child: Container(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: (destination.length / 3).ceil(),
                      itemBuilder: (BuildContext context, int index) {
                        final startIndex = index * 3;
                        final endIndex = (startIndex + 3 < destination.length)
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
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    print(destination);
                    sendMatricesToCloudFunction(distance, destination);
                  },
                  child: Text('Show possible paths'),
                ),
                SingleChildScrollView(
                  child: SizedBox(
                    height: 500,
                    child: PageView(
                      scrollDirection: Axis.horizontal,
                      children: _result.map((subList) {
                        // Create a local list to store elements from subList
                        List<String> localElements = [];

                        return Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 189, 218, 190),
                            border: Border.all(color: Colors.black),
                          ),
                          padding: EdgeInsets.all(8.0),
                          margin: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: List.generate(6, (index) {
                                  final currentDate = DateTime.now();
                                  final nextDate =
                                      currentDate.add(Duration(days: index));
                                  final formattedDate =
                                      "${nextDate.day.toString().padLeft(2, '0')}/${nextDate.month.toString().padLeft(2, '0')}";

                                  return Container(
                                    padding: EdgeInsets.all(9.0),
                                    child: Text(formattedDate),
                                  );
                                }),
                              ),
                              ...subList.map((element) {
                                // Add elements to the local list
                                localElements.add(element);

                                return FutureBuilder<List<String>>(
                                  future: WeatherUtil.getWeatherData(element),
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
                                          SizedBox(height: 10),
                                          Row(
                                            children: iconIds.map((iconId) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.5),
                                                child: Image.network(
                                                  'https://openweathermap.org/img/wn/$iconId.png',
                                                  width: 40,
                                                  height: 40,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return Icon(Icons.error);
                                                  },
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
                              // Display the elements from the localElements list
                              //for (var element in localElements) Text(element),
                              // FutureBuilder<String>(
                              //   future: distanceDuration
                              //       .calculateTotalDistanceAndDuration(
                              //           localElements),
                              //   builder: (context, snapshot) {
                              //     if (snapshot.connectionState ==
                              //         ConnectionState.waiting) {
                              //       return CircularProgressIndicator(); // or any other loading indicator
                              //     } else if (snapshot.hasError) {
                              //       return Text("Error: ${snapshot.error}");
                              //     } else if (snapshot.hasData) {
                              //       // Data has been received, so display it
                              //       return Text(snapshot.data!);
                              //     } else {
                              //       return Text("No data available");
                              //     }
                              //   },
                              // )
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return DrawPath(places: localElements);
                                    }),
                                  );
                                },
                                child: Text('Draw Path'),
                              ),
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
