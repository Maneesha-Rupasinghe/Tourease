import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourease/models/UserModel.dart';
import 'package:tourease/screens/authentication/authenticate.dart';
import 'package:tourease/screens/home/home.dart';
import 'package:tourease/screens/pages/test.dart';


class Wrapper extends StatelessWidget {
  const Wrapper({super.key});
  


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    if (user == null) {
      return const Authenticate();
    } else {
      return    Home();
  
    }
  }
}
