import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_pagination/firebase_pagination.dart';

class MyListView extends StatefulWidget {
  @override
  _MyListViewState createState() => _MyListViewState();
}

class _MyListViewState extends State<MyListView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Places List'),
      ),
      body: FirestorePagination(
        limit: 2, // Defaults to 10.
        viewType: ViewType.wrap,
        scrollDirection: Axis.horizontal, // Defaults to Axis.vertical.
        query: FirebaseFirestore.instance
            .collection('cities')
            .orderBy('name', descending: true),
        itemBuilder: (context, documentSnapshot, index) {
          final data = documentSnapshot.data() as Map<String, dynamic>?;
          if (data == null) return Container();

          return Container(
            constraints: const BoxConstraints(maxWidth: 169),
            child: Card(
              child: Text(data['name']),
            ),
          );
        },
        wrapOptions: const WrapOptions(
          alignment: WrapAlignment.start,
          direction: Axis.vertical,
          runSpacing: 10.0,
        ),
      ),
    );
  }
}