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
                            width: 70,
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
                      Container(
                        child: Column(
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
                      ),
                      const SizedBox(
                        height: 60,
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
                      SizedBox(
                        height: 300,
                        child: FirestorePagination(
                          limit: 2, // Defaults to 10.
                          viewType: ViewType.wrap,
                          scrollDirection:
                              Axis.horizontal, // Defaults to Axis.vertical.
                          query: FirebaseFirestore.instance
                              .collection('cities')
                              .orderBy('name', descending: true),
                          itemBuilder: (context, documentSnapshot, index) {
                            final data = documentSnapshot.data()
                                as Map<String, dynamic>?;
                            if (data == null) return Container();

                            return GestureDetector(
                              onTap: () {
                                // Define the data you want to pass to the next screen
                                String cardTitle = data['name'];

                                // Navigate to the desired screen and pass the data as an argument
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) {
                                    // Replace 'DestinationScreen' with the screen you want to navigate to
                                    return DestinationPage(cardTitle);
                                  },
                                ));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Display the image
                                    const Image(
                                      image: AssetImage('assets/google.png'),
                                      fit: BoxFit.cover,
                                      height: 275,
                                      width: 200,
                                    ),
                                    // Overlay with a dark shade
                                    Container(
                                      height: 275,
                                      width: 200,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.center,
                                          colors: [
                                            Colors.black.withOpacity(1),
                                            // Adjust the opacity as needed
                                            Colors.black.withOpacity(0.05),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 10,
                                      // Adjust the position as needed
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        // Adjust the radius as needed
                                        child: Container(
                                          alignment: Alignment.center,
                                          color: Colors.white,
                                          width: 150,
                                          // Adjust the width as needed
                                          height: 40,
                                          // Adjust the height as needed
                                          child: Text(
                                            data['name'],
                                            style: GoogleFonts.signika(
                                              textStyle: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ), // Your content goes here
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
                            runSpacing: 10.0,
                          ),
                        ),
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
