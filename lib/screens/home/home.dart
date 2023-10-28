import 'dart:ffi';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tourease/constants/colors.dart';
import 'package:tourease/constants/description.dart';
import 'package:tourease/constants/styles.dart';
import '../pages/destination.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/homeBack.jpg'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            constraints: const BoxConstraints.expand(),
            decoration: const BoxDecoration(),
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  //scrollDirection: Axis.vertical,
                  //padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 130,
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Row(children: [
                              Text(
                                'Tourease',
                                style: GoogleFonts.signika(
                                  textStyle: const TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ]),
                          ),
                          const SizedBox(
                            width: 65,
                          ),
                          SizedBox(
                              height: 40,
                              width: 50,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                // Adjust the radius as needed
                                child: IconButton(
                                  icon: const Icon(Icons.person_3_outlined),
                                  iconSize: 30,
                                  onPressed: () {
                                    // Handle button press
                                  },
                                ),
                              )),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Where do you wanna go?',
                            style: GoogleFonts.signika(
                              textStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: 320,
                            height: 35,
                            child: TextFormField(
                              style: const TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                suffixIcon: const Icon(
                                  Icons.search_outlined,
                                  color: Colors.white,
                                ),
                                labelText: 'Search',
                                labelStyle:
                                    const TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 260,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                              height: 40,
                              width: 150,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                // Adjust the radius as needed
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Handle button press
                                  },
                                  child: Text(
                                    'Trip Plans',
                                    style: GoogleFonts.signika(
                                      textStyle: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                          SizedBox(
                              height: 40,
                              width: 150,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                // Adjust the radius as needed
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Handle button press
                                  },
                                  child: Text(
                                    'Hotels',
                                    style: GoogleFonts.signika(
                                      textStyle: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 300,
                              width: 380,
                              child: FirestorePagination(
                                limit: 1,
                                viewType: ViewType.wrap,
                                scrollDirection: Axis.horizontal,
                                query: FirebaseFirestore.instance
                                    .collection('cities')
                                    .orderBy('name', descending: false),
                                itemBuilder:
                                    (context, documentSnapshot, index) {
                                  final data = documentSnapshot.data()
                                      as Map<String, dynamic>?;
                                  if (data == null) return Container();

                                  String cityName = data['name'];
                                  String imageUrl = data['featured_image'];

                                  return GestureDetector(
                                    onTap: () {
                                      String cardTitle = cityName;
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) {
                                          return DestinationPage(cardTitle);
                                        },
                                      ));
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Image(
                                            image: NetworkImage(imageUrl),
                                            fit: BoxFit.cover,
                                            height: 275,
                                            width: 186,
                                          ),
                                          Container(
                                            height: 275,
                                            width: 186,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.bottomCenter,
                                                end: Alignment.center,
                                                colors: [
                                                  Colors.black.withOpacity(1),
                                                  Colors.black
                                                      .withOpacity(0.05),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 10,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              child: Container(
                                                alignment: Alignment.center,
                                                color: Colors.white,
                                                width: 130,
                                                height: 40,
                                                child: Text(
                                                  cityName,
                                                  style: GoogleFonts.signika(
                                                    textStyle: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                wrapOptions: const WrapOptions(
                                  alignment: WrapAlignment.start,
                                  direction: Axis.vertical,
                                  runSpacing: 5.0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
