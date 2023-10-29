//import 'package:device_preview/device_preview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tourease/screens/pages/place.dart';
import 'package:tourease/screens/pages/placesScreen.dart';

import '../../constants/images.dart';

class DestinationPage extends StatelessWidget {
  String place = "";
  String a = '';
  DocumentReference? userName;
  //Future<String> description = '' as Future<String>;

  DestinationPage(String name) {
    place = name;
    //description = getDesription(place);


  }


  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Container(
                //height: 300,
                width: double.infinity,
                color: Color.fromARGB(255, 200, 219, 141),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Container(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromARGB(255, 252, 234, 160),
                          ),
                          child: Text(
                            '$place',
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: SingleChildScrollView(
                          child: Text(
                          'abcdhgbhbv nbfyebhe  uibui4 ev3riw rb7rv3 h 3vuih qi h3h rgwgeyf we yw',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: FirestorePagination(
                      limit: 2, // Defaults to 2.
                      viewType: ViewType.wrap,
                      scrollDirection: Axis.vertical, // Defaults to Axis.vertical.
                      query: FirebaseFirestore.instance
                          .collection('cities').doc(place.toLowerCase()).collection('places')
                          .orderBy('name', descending: false),
                      itemBuilder: (context, documentSnapshot, index) {
                        final data = documentSnapshot.data() as Map<String, dynamic>?;
                        if (data == null) return Container();

                        return GestureDetector(
                          onTap: () {
                            // Define the data you want to pass to the next screen
                            String cardTitle = data['name'];

                            // Navigate to the desired screen and pass the data as an argument
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                // Replace 'DestinationScreen' with the screen you want to navigate to
                                return placesScreen(cardTitle,place.toLowerCase());
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
                                  image: AssetImage(sigiriya),
                                  fit: BoxFit.cover,
                                  height: 225,
                                  width: 175,
                                ),
                                // Overlay with a dark shade
                                Container(
                                  height: 225,
                                  width: 175,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.center,
                                      colors: [
                                        Colors.black.withOpacity(1),
                                        // Adjust the opacity as needed
                                        Colors.black
                                            .withOpacity(0.05),
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
                                            fontWeight:
                                            FontWeight.bold,
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
                        direction: Axis.horizontal,
                        runSpacing: 10.0,
                        //clipBehavior: Clip.none,
                      ),
                    ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }


}
