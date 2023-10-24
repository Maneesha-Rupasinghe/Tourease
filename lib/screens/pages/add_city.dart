import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChooseCity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CityButton(cityName: 'Colombo'),
        CityButton(cityName: 'Matara'),
        CityButton(cityName: 'Galle'),
        CityButton(cityName: 'Kandy'),
        CityButton(cityName: 'Jaffna'),
      ],
    );
  }
}

class CityButton extends StatefulWidget {
  final String cityName;

  CityButton({required this.cityName});

  @override
  _CityButtonState createState() => _CityButtonState();
}

class _CityButtonState extends State<CityButton> {
  bool isSelected = false;

  void toggleSelection() {
    setState(() {
      isSelected = !isSelected;
    });
  }

  void saveCityToFirestore() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      String userUid = user.uid;
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentReference userDocument = firestore.collection('users').doc(userUid);

      userDocument.get().then((docSnapshot) {
        if (docSnapshot.exists) {
          List<String> selectedCities = List<String>.from((docSnapshot.data() as Map<String, dynamic>)['selected_cities'] ?? []);
          if (isSelected) {
            selectedCities.add(widget.cityName);
          } else {
            selectedCities.remove(widget.cityName);
          }

          userDocument.update({'selected_cities': selectedCities}).then((_) {
            print('City "${widget.cityName}" updated for User: $userUid');
          }).catchError((error) {
            print('Error updating user cities: $error');
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        toggleSelection();
        saveCityToFirestore();
      },
      child: Text(widget.cityName),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (isSelected) {
            return Colors.green; 
          } else {
            return null;
          }
        }),
      ),
    );
  }
}
