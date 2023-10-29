// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tourease/screens/authentication/login.dart';
import 'package:tourease/screens/pages/my_plans.dart';
import 'package:tourease/services/auth.dart';
import 'package:tourease/screens/authentication/login.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  //final User? user = FirebaseAuth.instance.currentUser;
  //final firestore = FirebaseFirestore.instance;
  //List<DocumentSnapshot> userPlans = [];
  String? userName;
  final User? user = FirebaseAuth.instance.currentUser;
  final firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> userPlans = [];
  final AuthServices _auth = AuthServices();
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  File? _imageFile; // Selected image file
  final ImagePicker _imagePicker = ImagePicker();
  String? profilePictureURL;

  @override
  void initState() {
    super.initState();
    if (user != null) {
      clearFirestoreCache(); // Clear Firestore cache
      fetchUserPlans();
    }
    fetchUserData();
    fetchUserName();
  }

  Future<void> fetchUserName() async {
    final userDoc = firestore.collection('users').doc(user!.uid);
    final userSnapshot = await userDoc.get();

    if (userSnapshot.exists) {
      final userData = userSnapshot.data() as Map<String, dynamic>;
      setState(() {
        userName = '${userData['firstName']} ${userData['lastName']}';
      });
    }
  }

  Future<void> clearFirestoreCache() async {
    await FirebaseFirestore.instance.clearPersistence();
  }

  Future<void> fetchUserPlans() async {
    final userDoc = firestore.collection('users').doc(user!.uid);
    final userPlansCollection = userDoc.collection('user_plans');
    final userPlansSnapshot = await userPlansCollection.get();

    setState(() {
      userPlans = userPlansSnapshot.docs;
    });
  }

  Future<void> _showPlanDetails(DocumentSnapshot plan) async {
    final data = plan.data() as Map<String, dynamic>;

    // Extract the "your_list_field_name" from the document data
    final planName = data['your_list_field_name'];

    showDialog(
      context: context,
      builder: (context) {
        final destinations = (planName as List).join(' -> ');
        return AlertDialog(
          title: Text('Plan Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Destination: $destinations'),
              // Add more details here if needed
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectImage() async {
    final XFile? pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  Future<void> _uploadProfileImageAndSaveChanges() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final uid = user.uid;

      if (_imageFile != null) {
        final Reference storageReference =
            FirebaseStorage.instance.ref().child('profile_pictures/$uid.jpg');
        final UploadTask uploadTask = storageReference.putFile(_imageFile!);

        await uploadTask.whenComplete(() async {
          final url = await storageReference.getDownloadURL();

          await FirebaseFirestore.instance.collection('users').doc(uid).update({
            'profilePictureURL': url,
          });

          updateProfileData();
          Navigator.pop(context);
        });
      } else {
        updateProfileData();
        Navigator.pop(context);
      }
    }
  }

  void updateProfileData() {
    final String newFirstName = _fnameController.text;
    final String newLastName = _lnameController.text;
    final String newMobileNumber = _mobileNumberController.text;
    final String newAddress = _addressController.text;

    final User? user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;

    if (uid != null) {
      FirebaseFirestore.instance.collection('users').doc(uid).update({
        'firstName': newFirstName,
        'lastName': newLastName,
        'mobileNumber': newMobileNumber,
        'address': newAddress,
      });
    }
  }

  Future<void> fetchUserData() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final uid = user.uid;
      final DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userSnapshot.exists) {
        final Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;

        _fnameController.text = userData['firstName'] ?? '';
        _lnameController.text = userData['lastName'] ?? '';
        _mobileNumberController.text = userData['mobileNumber'] ?? '';
        _addressController.text = userData['address'] ?? '';
        profilePictureURL = userData['profilePictureURL'];
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    _fnameController.dispose();
    _lnameController.dispose();
    _mobileNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/homeBack.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 145,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Row(children: [
                    Text(
                      'Profile',
                      style: GoogleFonts.signika(
                        textStyle: const TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ]),
                ),
                const SizedBox(
                  width: 90,
                ),
                IconButton(
                  icon: const Icon(Icons.logout_outlined),
                  iconSize: 30,
                  onPressed: () async {
                    await _auth.signOut();
                  },
                )
              ],
            ),
            GestureDetector(
              onTap: () {
                _selectImage();
              },
              child: ClipOval(
                child: Center(
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: profilePictureURL != null
                            ? NetworkImage(profilePictureURL!)
                            : (_imageFile != null
                                ? FileImage(_imageFile!)
                                    as ImageProvider<Object>
                                : const AssetImage('assets/placeholder.webp')),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            if (userName != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 115,
                  ),
                  Text(
                    ' $userName',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_square),
                    iconSize: 25,
                    onPressed: () {
                      // Navigate to the tripPlan screen
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return EditProfile2();
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Color.fromARGB(171, 255, 255, 255),
              ),
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Recent Plans", // Add the text here
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity, // Adjust the width as needed
                    height: 400,
                    child: userPlans.isNotEmpty
                        ? ListView.builder(
                            itemCount: userPlans.length,
                            itemBuilder: (context, index) {
                              final plan = userPlans[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical:
                                        5.0), // Adjust the vertical spacing as needed
                                child: Card(
                                  elevation: 3,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 30),
                                  child: ListTile(
                                    title: Text('Plan ${index + 1}'),
                                    tileColor: Colors.white,
                                    onTap: () => _showPlanDetails(plan),
                                  ),
                                ),
                              );
                            },
                          )
                        : const Center(
                            child: Text('You have no plans.'),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
