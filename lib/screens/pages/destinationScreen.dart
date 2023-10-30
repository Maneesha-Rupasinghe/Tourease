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
    CollectionReference docu = FirebaseFirestore.instance.collection('cities');

    return FutureBuilder<DocumentSnapshot>(
      future: docu.doc(place.toLowerCase()).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.black.withOpacity(0.0),
                title: Center(
                  child: Text(data['name'],
                      style: GoogleFonts.nunito(
                          fontWeight: FontWeight.bold, fontSize: 30)),
                ),
                leading: GestureDetector(
                  child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new_outlined,
                        size: 25,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
                actions: [
                  IconButton(
                      onPressed: null,
                      icon: Icon(
                        Icons.person_outlined,
                        size: 25,
                      ))
                ],
              ),
              body: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(homeBack),
                            fit: BoxFit.cover,
                            opacity: 0.9)),
                    child: Column(
                      children: [
                        Container(
                          //height: 300,
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 25,
                              ),
                              Container(
                                color: Colors.transparent,
                                child: Text(
                                  data['description'],
                                  style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: SingleChildScrollView(
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.6,
                              child: FirestorePagination(
                                limit: 2,
                                // Defaults to 2.
                                viewType: ViewType.wrap,
                                scrollDirection: Axis.vertical,
                                // Defaults to Axis.vertical.
                                query: FirebaseFirestore.instance
                                    .collection('cities')
                                    .doc(place.toLowerCase())
                                    .collection('places')
                                    .orderBy('name', descending: false),
                                itemBuilder:
                                    (context, documentSnapshot, index) {
                                  final data = documentSnapshot.data()
                                      as Map<String, dynamic>?;
                                  if (data == null) return Container();

                                  return GestureDetector(
                                    onTap: () {
                                      // Define the data you want to pass to the next screen
                                      String cardTitle = data['name'];

                                      // Navigate to the desired screen and pass the data as an argument
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) {
                                          // Replace 'DestinationScreen' with the screen you want to navigate to
                                          return placesScreen(
                                              collectionName: cardTitle,
                                              documentName:
                                                  place.toLowerCase());
                                        },
                                      ));
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          // Display the image
                                          SizedBox(
                                            height: 200,
                                            width: 300,
                                            child: Image.network(data['featured_image'],fit: BoxFit.cover,),
                                          ),
                                          // Overlay with a dark shade
                                          Container(
                                            height: 200,
                                            width: 300,
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
                  Container(
                    child: Positioned(
                        left: 100,
                        right: 100,
                        bottom: 20,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          // Adjust the radius as needed
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle button press
                            },
                            child: Text(
                              'ADD TO PLAN',
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
                  ),
                ],
              ));
        }
        return Text("loading");
      },
    );
  }
}
