// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tourease/screens/pages/my_plans.dart';
import 'package:tourease/services/auth.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(' Profile'),
        actions: [
          ElevatedButton(
            onPressed: () async {
              await _auth.signOut();
            },
            child: const Icon(Icons.logout),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Center(
          child: SingleChildScrollView(
            // Wrap with SingleChildScrollView
            child: Column(
              children: [
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
                                    : const AssetImage(
                                        'assets/placeholder.webp')),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                if (userName != null)
                  Row(
                    children: [
                      Text(
                        ' $userName',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.person_3_outlined),
                        iconSize: 30,
                        onPressed: () {
                          // Navigate to the tripPlan screen
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return EditProfilePage();
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                if (userPlans.isNotEmpty)
                  Container(
                    // Wrap with a Container
                    height:
                        400, // Define a fixed height or use other constraints as needed
                    child: ListView.builder(
                      itemCount: userPlans.length,
                      itemBuilder: (context, index) {
                        final plan = userPlans[index];
                        return Card(
                          elevation: 3,
                          margin:
                              EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                          child: ListTile(
                            title: Text('Plan ${index + 1}'),
                            tileColor: Colors.white,
                            onTap: () => _showPlanDetails(plan),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
