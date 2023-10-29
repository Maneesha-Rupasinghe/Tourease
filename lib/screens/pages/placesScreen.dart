import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
String place = 'lotus tower';
String city = 'colombo';

class placesScreen extends StatelessWidget {


  placesScreen(String name1, String name2, {super.key}) {
    place = name1;
    city = name2;
    //description = getDesription(place);

  }

  TextEditingController controller1 = TextEditingController();

  var imageURL = 'https://previews.123rf.com/images/gumbao/gumbao1509/gumbao150900016/44987080-kiefer-firest-auf-la-marina-an-der-k%C3%BCste-des-mittelmeers-costa-blanca-spanien.jpg';
  final Stream<QuerySnapshot> _data = FirebaseFirestore.instance.collection('cities').doc(city).collection(place).snapshots();

  //TextEditingController controller2 = TextEditingController();


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:
      StreamBuilder<QuerySnapshot>(
        stream: _data,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String,
                  dynamic>;
              return ListTile(
                title: Text(data['name'],style: Theme.of(context).textTheme.headline1,
                ),
                subtitle: Image(
                  image: NetworkImage(data['featured_image']), // ----------- the line that should change
                  width: 300,
                  height: 300,

                ),
              );
            }).toList(),
          );

        },
      ),
    );
  }


}


