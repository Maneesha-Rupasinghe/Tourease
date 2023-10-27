import 'package:flutter/material.dart';
import 'package:tourease/screens/pages/add_city.dart';
import 'package:tourease/screens/pages/trip_plan.dart';
import 'package:tourease/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Create an object from AuthServices
  final AuthServices _auth = AuthServices();

  // Initialize selectedCities as an empty list
  List<String> selectedCities = [];

  // Fetch the user's selected cities from Firestore
  void fetchSelectedCities() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      String userUid = user.uid;
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentReference userDocument = firestore.collection('users').doc(userUid);

      userDocument.get().then((docSnapshot) {
        if (docSnapshot.exists) {
          // Get the user's selected cities from Firestore
          selectedCities = List<String>.from((docSnapshot.data() as Map<String, dynamic>)['selected_cities'] ?? []);
          setState(() {}); 
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSelectedCities(); 
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          actions: [
            ElevatedButton(
              onPressed: () async {
                await _auth.signOut();
              },
              child: const Icon(Icons.logout),
            )
          ],
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ChooseCity(selectedCities: selectedCities),
                      ),
                    );
                  },
                  child: const Text("Add City"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>  tripPlan(),
                      ),
                    );
                  },
                  child: const Text("Trip plan"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
