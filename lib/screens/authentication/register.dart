import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/styles.dart';
import '../../services/auth.dart';

class Register extends StatefulWidget {
  final Function toggle;

  const Register({Key? key, required this.toggle}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthServices _auth = AuthServices();

  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String error = "";
  String fname = "";
  String lname = "";
  String mobilenumber = "";
  String address = "";

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/register.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.white.withOpacity(0.7),
                  ),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Text(
                          "SIGN UP",
                          style: signInRegisterText3,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                style: const TextStyle(color: Colors.black),
                                decoration: textInputdecorataion,
                                validator: (val) => val?.isEmpty == true
                                    ? "Enter a valid email"
                                    : null,
                                onChanged: (val) {
                                  setState(() {
                                    email = val;
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 7,
                              ),
                              TextFormField(
                                style: const TextStyle(color: Colors.black),
                                decoration: textInputdecorataion.copyWith(
                                    hintText: "First Name"),
                                validator: (val) => val?.isEmpty == true
                                    ? "Enter the first name"
                                    : null,
                                onChanged: (val) {
                                  setState(() {
                                    fname = val;
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 7,
                              ),
                              TextFormField(
                                style: const TextStyle(color: Colors.black),
                                decoration: textInputdecorataion.copyWith(
                                    hintText: "Last Name"),
                                validator: (val) => val?.isEmpty == true
                                    ? "Enter the last name"
                                    : null,
                                onChanged: (val) {
                                  setState(() {
                                    lname = val;
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 7,
                              ),
                              TextFormField(
                                style: const TextStyle(color: Colors.black),
                                decoration: textInputdecorataion.copyWith(
                                    hintText: "Mobile Number"),
                                validator: (val) => val?.isEmpty == true
                                    ? "Enter the mobile number"
                                    : null,
                                onChanged: (val) {
                                  setState(() {
                                    mobilenumber = val;
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 7,
                              ),
                              TextFormField(
                                style: const TextStyle(color: Colors.black),
                                decoration: textInputdecorataion.copyWith(
                                  hintText: "password",
                                ),
                                validator: (val) => val!.length < 6
                                    ? "Enter a valid password"
                                    : null,
                                onChanged: (val) {
                                  setState(() {
                                    password = val;
                                  });
                                },
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () async {
                                  dynamic result =
                                      await _auth.registerWithEmailAndPassword(
                                          email,
                                          fname,
                                          lname,
                                          mobilenumber,
                                          address,
                                          password);
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blue, // Background color
                                  onPrimary: Colors.white, // Text color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10), // Adjust the border radius
                                  ),
                                ),
                                child: Container(
                                  width: 200,
                                  height: 40,
                                  child: Center(
                                    child: Text(
                                      "REGISTER",
                                      style: startButtonText,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Divider(
                                color: Colors.black,
                                height: 1,
                                thickness: 1,
                                indent: 40,
                                endIndent: 40,
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                "Login with social accounts",
                                style: signInRegisterText2,
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {},
                                    child: Center(
                                      child: Image.asset(
                                        'assets/facebook.png',
                                        height: 40,
                                        width: 40,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Center(
                                      child: Image.asset(
                                        'assets/google.png',
                                        height: 62,
                                        width: 62,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Do you have an account?",
                                    style: signInRegisterText2,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      widget.toggle();
                                    },
                                    child: const Text(
                                      "LOGIN",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 18,
                                        decoration: TextDecoration
                                            .underline, // Apply underline
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
