
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourease/models/UserModel.dart';
import 'package:tourease/screens/wrapper.dart';
import 'package:tourease/services/auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel?>.value(
      value: AuthServices().user,
      initialData: UserModel(uid: ""),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
        //home: EditProfilePage(),
      ),
    );
  }
}
