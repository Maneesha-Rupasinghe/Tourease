import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChooseCity extends StatefulWidget {
  final List<String> selectedCities;

  ChooseCity({required this.selectedCities});

  @override
  _ChooseCityState createState() => _ChooseCityState(selectedCities);
}

class _ChooseCityState extends State<ChooseCity> {
  final List<String> selectedCities;
  _ChooseCityState(this.selectedCities);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CityButton(cityName: 'Colombo', isSelected: selectedCities.contains('Colombo')),
        CityButton(cityName: 'Matara', isSelected: selectedCities.contains('Matara')),
        CityButton(cityName: 'Galle', isSelected: selectedCities.contains('Galle')),
        CityButton(cityName: 'Kandy', isSelected: selectedCities.contains('Kandy')),
        CityButton(cityName: 'Jaffna', isSelected: selectedCities.contains('Jaffna')),
      ],
    );
  }
}

class CityButton extends StatefulWidget {
  final String cityName;
  final bool isSelected;

  CityButton({required this.cityName, required this.isSelected});

  @override
  _CityButtonState createState() => _CityButtonState(isSelected);
}

class _CityButtonState extends State<CityButton> {
  bool isSelected;
  
  _CityButtonState(this.isSelected);

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
