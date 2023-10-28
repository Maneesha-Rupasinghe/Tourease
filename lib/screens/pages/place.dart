import 'package:flutter/material.dart';

class placepage extends StatefulWidget {
  const placepage({super.key});

  @override
  State<placepage> createState() => _HomepageState();
}

class _HomepageState extends State<placepage> {
  TextEditingController controller1 = TextEditingController();
  //TextEditingController controller2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
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
                Padding(
                  padding: const EdgeInsets.all(2),
                  child: Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Image(
                          image: AssetImage(
                        'assests/colombo.png',
                      ))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
