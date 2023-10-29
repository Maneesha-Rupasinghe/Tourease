import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
            body: SafeArea(
              child: Center(
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(218, 146, 98, 10),
                      ),
                      padding: EdgeInsets.only(left: 1.8),
                      margin: EdgeInsets.only(top: 3),
                      child: Text(
                        data['name'],
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white70,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: Container(
                          height: 150,
                          child: Image.network(data['featured_image'])),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return Text("loading");
      },
    );
  }
}



