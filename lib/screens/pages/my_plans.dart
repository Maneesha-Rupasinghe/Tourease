import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyPlans extends StatefulWidget {
  const MyPlans({Key? key}) : super(key: key);

  @override
  State<MyPlans> createState() => _MyPlansState();
}

class _MyPlansState extends State<MyPlans> {
  final User? user = FirebaseAuth.instance.currentUser;
  final firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> userPlans = [];

  @override
  void initState() {
    super.initState();
    if (user != null) {
      clearFirestoreCache(); // Clear Firestore cache
      fetchUserPlans();
    }
  }

  // Clear Firestore cache
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Plans'),
      ),
      body: userPlans.isNotEmpty
          ? ListView.builder(
              itemCount: userPlans.length,
              itemBuilder: (context, index) {
                final plan = userPlans[index];
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                  child: ListTile(
                    title: Text('Plan ${index + 1}'),
                    tileColor: Colors.white,
                    onTap: () => _showPlanDetails(plan),
                  ),
                );
              },
            )
          : const Center(
              child: Text('You have no plans.'),
            ),
    );
  }
}
