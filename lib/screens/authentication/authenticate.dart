import 'package:flutter/material.dart';
import 'package:tourease/screens/authentication/login.dart';
import 'package:tourease/screens/authentication/register.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool singingPage = true;

  //toggle pages
  void switchPages() {
    setState(() {
      singingPage = !singingPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (singingPage == true) {
      return SingIn(toggle: switchPages);
    } else {
      return Register(toggle: switchPages);
    }
  }
}
