import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/images.dart';

String place = 'lotus tower';
String city = 'colombo';

class placesScreen extends StatelessWidget {

  final String collectionName;
  final String documentName;

  placesScreen({
    required this.collectionName,
    required this.documentName,
  });


  @override
  Widget build(BuildContext context) {
    CollectionReference docu = FirebaseFirestore.instance.collection('cities').doc(documentName).collection('places');

    return FutureBuilder<DocumentSnapshot>(
      future: docu.doc(collectionName).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.black.withOpacity(0.0),
                title: Center(
                  child: Text(data['name'], style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      fontSize: 30
                  )
                  ),
                ),
                leading: GestureDetector(
                  child: IconButton(
                      icon: Icon(Icons.arrow_back_ios_new_outlined,
                        size: 25,),
                      onPressed: () {
                        Navigator.pop(context);
                      }
                  ),
                ),
                actions: [
                  IconButton(onPressed: null, icon: Icon(Icons.person_outlined,size: 25,))
                ],

              ),
              body: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(homeBack), fit: BoxFit.cover, opacity: 0.9)),
                    child: Column(
                      children: [
                        Container(
                          //height: 300,
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 25,),
                              Container(
                                color: Colors.transparent,
                                child: Text(data['description'], style: GoogleFonts.nunito(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                                ),
                              ),

                            ],
                          ),
                        ),
                        SizedBox(height: 25,),
                        SizedBox(
                          height: 300,
                          width: 200,
                          child: Image.network(data['featured_image']),
                        )

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
                        )
                    ),
                  ),
                ],
              )

          );;
        }

        return Text("loading");
      },
    );
  }
}



