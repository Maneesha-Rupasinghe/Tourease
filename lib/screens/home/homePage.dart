import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/images.dart';
import '../constants/images.dart';
import '../pages/destinationScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu_rounded),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          title: const Text('Hi Abhiman'),
          actions: const [
            Icon(
              Icons.person,
              size: 40,
            ),
            SizedBox(
              width: 10,
            )
          ],
        ),
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.login_outlined,
                ),
                title: Text(
                  'SignIn',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.logout_outlined,
                ),
                title: Text(
                  'SignOut',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: Container(
            constraints: const BoxConstraints.expand(),
            decoration: const BoxDecoration(
            ),
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  //scrollDirection: Axis.vertical,
                  //padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      const SizedBox(
                        height: 20,
                      ),
                      Row(children: [
                        Text(
                          'Where do you \nwanna go?',
                          style: GoogleFonts.signika(
                            textStyle: const TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ]),
                      const SizedBox(
                        height: 35,
                      ),
                      SizedBox(
                        width: 300,
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
                            labelStyle: const TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
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
                          limit: 2, // Defaults to 2.
                          viewType: ViewType.wrap,
                          scrollDirection: Axis.horizontal, // Defaults to Axis.vertical.
                          query: FirebaseFirestore.instance
                              .collection('cities')
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
                                      image: AssetImage(sigiriya),
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
                            direction: Axis.vertical,
                            runSpacing: 10.0,
                            //clipBehavior: Clip.none,
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
            )));
  }
}
