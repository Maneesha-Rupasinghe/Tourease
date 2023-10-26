import 'package:flutter/material.dart';
import 'package:tourease/screens/pages/add_city.dart';
import 'package:tourease/screens/pages/destination.dart';
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
  TextEditingController controller1 = TextEditingController();
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
      DocumentReference userDocument =
          firestore.collection('users').doc(userUid);

      userDocument.get().then((docSnapshot) {
        if (docSnapshot.exists) {
          // Get the user's selected cities from Firestore
          selectedCities = List<String>.from(
              (docSnapshot.data() as Map<String, dynamic>)['selected_cities'] ??
                  []);
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
    String name = '';
    return Scaffold(
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                autofocus: true, //maximum text length
                keyboardType: TextInputType.name, //can only type numbers
                style: TextStyle(fontSize: 20),
                controller: controller1,
                onSubmitted: (text) {
                  name = controller1.text;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) {
                        return DestinationPage(name);
                      },
                    ),
                  );
                },
                decoration: InputDecoration(
                  filled: true,
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      controller1.text = '';
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 200,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 195,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            name = 'KANDY';
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (_) {
                              return DestinationPage(name);
                            }));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: Container(
                              height: 200,
                              width: 150,
                              color: Color.fromARGB(255, 213, 198, 154),
                              margin: EdgeInsets.only(right: 10),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(218, 146, 98, 10),
                                      ),
                                      padding: EdgeInsets.only(left: 1.8),
                                      margin: EdgeInsets.only(top: 3),
                                      child: Text(
                                        'KANDY',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Container(
                                          height: 155,
                                          child: Image(
                                              image: AssetImage(
                                            'assests/kandy.png',
                                          ))),
                                    )
                                  ]),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            name = 'GALLE';
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (_) {
                              return DestinationPage(name);
                            }));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: Container(
                              height: 200,
                              width: 150,
                              color: Color.fromARGB(255, 213, 198, 154),
                              margin: EdgeInsets.only(right: 10),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(218, 146, 98, 10),
                                      ),
                                      padding: EdgeInsets.only(left: 1.8),
                                      margin: EdgeInsets.only(top: 3),
                                      child: Text(
                                        'GALLE',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Container(
                                          height: 155,
                                          child: Image(
                                              image: AssetImage(
                                            'assests/galle.png',
                                          ))),
                                    )
                                  ]),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            name = 'ANURADHAPURA';
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (_) {
                              return DestinationPage(name);
                            }));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: Container(
                              height: 200,
                              width: 150,
                              color: Color.fromARGB(255, 213, 198, 154),
                              margin: EdgeInsets.only(right: 10),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(218, 146, 98, 10),
                                      ),
                                      padding: EdgeInsets.only(left: 1.8),
                                      margin: EdgeInsets.only(top: 3),
                                      child: Text(
                                        'ANURADAPURA',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Container(
                                          height: 155,
                                          child: Image(
                                              image: AssetImage(
                                            'assests/anuradapura.png',
                                          ))),
                                    )
                                  ]),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            name = 'COLOMBO';
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (_) {
                              return DestinationPage(name);
                            }));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: Container(
                              height: 200,
                              width: 150,
                              color: Color.fromARGB(255, 213, 198, 154),
                              margin: EdgeInsets.only(right: 10),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(218, 146, 98, 10),
                                      ),
                                      padding: EdgeInsets.only(left: 1.8),
                                      margin: EdgeInsets.only(top: 3),
                                      child: Text(
                                        'COLOMBO',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Container(
                                          height: 155,
                                          child: Image(
                                              image: AssetImage(
                                            'assests/colombo.png',
                                          ))),
                                    )
                                  ]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        ChooseCity(selectedCities: selectedCities),
                  ),
                );
              },
              child: const Text("Add City"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => tripPlan(),
                  ),
                );
              },
              child: const Text("Trip plan"),
            ),
          ],
        ),
      ),
    );
  }
}
