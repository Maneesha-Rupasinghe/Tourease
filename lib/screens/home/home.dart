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
