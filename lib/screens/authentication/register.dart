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
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/sigiriya2.jpg'),
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
                padding: const EdgeInsets.only(top: 15),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.white.withOpacity(0.7),
                  ),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          "Register",
                          style: signInRegisterText3,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "description",
                        style: descriptionStyle,
                      ),
                      // Center(
                      //   child: Image.asset(
                      //     'assets/register.png',
                      //     height: 100,
                      //     width: 100,
                      //   ),
                      // ),
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
                              // TextFormField(
                              //   style: const TextStyle(color: Colors.black),
                              //   decoration: textInputdecorataion.copyWith(
                              //     hintText: "Address",
                              //   ),
                              //   validator: (val) => val?.isEmpty == true
                              //       ? "Enter the address"
                              //       : null,
                              //   onChanged: (val) {
                              //     setState(() {
                              //       address = val;
                              //     });
                              //   },
                              // ),
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
                                        'assets/facebook.jpg',
                                        height: 50,
                                        width: 50,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Center(
                                      child: Image.asset(
                                        'assets/google.png',
                                        height: 50,
                                        width: 50,
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
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: () async {
                                  dynamic result =
                                      await _auth.registerWithEmailAndPassword(
                                          email,
                                          fname,
                                          lname,
                                          mobilenumber,
                                          address,
                                          password);
                                },
                                child: Container(
                                  height: 40,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 245, 229, 184),
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                      width: 3,
                                      color: Color.fromARGB(255, 245, 229, 184),
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "REGISTER",
                                      style: startButtonText,
                                    ),
                                  ),
                                ),
                              ),
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
