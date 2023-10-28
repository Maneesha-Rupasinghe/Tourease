//import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:tourease/screens/pages/place.dart';

class DestinationPage extends StatelessWidget {
  String place = "";

  DestinationPage(String name) {
    place = name;
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
                            'Colombo is the dream vacation destination for people who long to expColombo is the dream vacation destination for people who long to experiencColombo is the dream vacation destination for people who long to experiencColombo is the dream vacation destination for people who long to experiencColombo is the dream vacation destination for people who long to experiencColombo is the dream vacation destination for people who long to experiencr people who long to experience the wonders of a tropical paradise. With stunning beaches, delectable food, hospitable people, great colonial heritage sites and tourist activities galore, there is something for everyone.',
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
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      children: [
                        Column(
                          children: [
                            Container(
                              height: 200,
                              width: double.infinity,
                              color: Color.fromRGBO(255, 255, 255, 1),
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
                                        'LOTUS TOWER',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(builder: (_) {
                                          return placepage();
                                        }));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: Container(
                                            height: 150,
                                            child: Image(
                                                image: AssetImage(
                                              'assests/colombo.png',
                                            ))),
                                      ),
                                    ),
                                  ]),
                            ),
                            Container(
                              height: 200,
                              width: double.infinity,
                              color: Color.fromARGB(255, 255, 255, 255),
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
                                        'ONEGALLEFACE',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(builder: (_) {
                                          return placepage();
                                        }));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: Container(
                                            height: 150,
                                            child: Image(
                                                image: AssetImage(
                                              'assests/colombo.png',
                                            ))),
                                      ),
                                    ),
                                  ]),
                            ),
                            Container(
                              height: 200,
                              width: double.infinity,
                              color: Color.fromARGB(255, 255, 255, 255),
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
                                        'ONEGALLEFACE',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(builder: (_) {
                                          return placepage();
                                        }));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: Container(
                                            height: 150,
                                            child: Image(
                                                image: AssetImage(
                                              'assests/colombo.png',
                                            ))),
                                      ),
                                    ),
                                  ]),
                            ),
                            Container(
                              height: 200,
                              width: double.infinity,
                              color: Color.fromARGB(255, 255, 255, 255),
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
                                        'ONEGALLEFACE',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(builder: (_) {
                                          return placepage();
                                        }));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: Container(
                                            height: 150,
                                            child: Image(
                                                image: AssetImage(
                                              'assests/colombo.png',
                                            ))),
                                      ),
                                    ),
                                  ]),
                            ),
                          ],
                        ),
                      ],
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
