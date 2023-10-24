import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  // Create a list to store the first and last elements
  List<String> firstAndLastElements = [];
  

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

        
        
      });
    } else {
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
          List<String> cities = selectedCitiesData.map((city) => city.toString()).toList();
          destination.addAll(cities); // Add the retrieved cities to your list
          return cities;
        }
      }
    }

    // Handle the case where the user's document doesn't exist or the data is not in the expected format.
    return [];
  } catch (e) {
    // Handle any errors that occur during the retrieval.
    return [];
  }
}
String? getCurrentUserId() {
  final User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return user.uid;
  } else {
    return null; // No user is signed in.
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
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                print(destination);
                sendMatricesToCloudFunction(distance, destination);
              },
              child: Text('Send Matrices to Cloud Function'),
            ),
            // Display the result as a list (matrix)
            if (_result.isNotEmpty) // Check if the result is not empty
              Column(
                children: _result.map((row) {
                  return Row(
                    children: row.map((element) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(element),
                      );
                    }).toList(),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    ),
  );
}

}
