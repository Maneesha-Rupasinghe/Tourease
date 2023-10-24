import 'package:flutter/material.dart';
import 'package:tourease/screens/pages/add_city.dart';

import 'package:tourease/services/auth.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Create an object from AuthServices
  final AuthServices _auth = AuthServices();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("home"),
          actions: [
            ElevatedButton(
              onPressed: () async {
                await _auth.signOut();
              },
              child: const Icon(Icons.logout),
            )
          ],
        ),
        // Add the rest of your widget tree here
        body: SafeArea(
          child: Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        ChooseCity(), // Instantiate the NumberDoubler widget
                  ),
                );
              },
              child: const Text("Press"),
            ),
            
          ),
        ),
      ),
    );
  }
}
