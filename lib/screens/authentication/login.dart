import 'package:flutter/material.dart';
import 'package:tourease/constants/colors.dart';
import 'package:tourease/constants/styles.dart';
import 'package:tourease/services/auth.dart';

class SingIn extends StatefulWidget {
  // Function
  final Function toggle;

  const SingIn({Key? key, required this.toggle}) : super(key: key);

  @override
  State<SingIn> createState() => _SingInState();
}

class _SingInState extends State<SingIn> {
  // Reference for the AuthService class
  final AuthServices _auth = AuthServices();

  // Form key
  final _formKey = GlobalKey<FormState>();

  // Email and password states
  String email = "";
  String password = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/sigiriya.png'), // Replace with your image path
            fit: BoxFit.cover, // Set to BoxFit.cover
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Padding(
            padding: EdgeInsets.only(top: 90), // Corrected this line
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: signInRegisterbackgroundWhite.withOpacity(0.7),
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      "Sign In",
                      style: signInRegisterText3,
                    ),
                  ),
                  // Description
                  // const Text(
                  //   "Sign In",
                  //   style: signInRegisterText,
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Email
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
                            height: 14,
                          ),
                          // Password
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
                          // Google
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            error,
                            style: const TextStyle(color: Colors.red),
                          ),
                          const Text(
                            "Login with social accounts",
                            style: signInRegisterText,
                          ),
                          const Divider(
                            color: Colors.black,
                            height: 20,
                            thickness: 1,
                            indent: 40,
                            endIndent: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                // Sign in with Facebook
                                onTap: () {},
                                child: Center(
                                  child: Image.asset(
                                    'assets/facebook.jpg',
                                    height: 50,
                                    width: 50,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              GestureDetector(
                                // Sign in with Google
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
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Do not have an account",
                                style: signInRegisterText2,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                // Go to the register page
                                onTap: () {
                                  widget.toggle();
                                },
                                child: const Text(
                                  "REGISTER",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            // Method for log in
                            onTap: () async {
                              dynamic result = await _auth
                                  .signInUsingEmailAndPassword(email, password);
                              if (result == null) {
                                setState(() {
                                  error =
                                      "User name or password is not matching ";
                                });
                              }
                            },
                            child: Container(
                              height: 40,
                              width: 200,
                              decoration: BoxDecoration(
                                color: startButtonGreen,
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                  width: 3,
                                  color: startButtonGreen,
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  "LOG IN",
                                  style: (startButtonText),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            // Method for log in as guest
                            onTap: () async {
                              await _auth.signInAnonoymously();
                            },
                            child: Container(
                              height: 40,
                              width: 300,
                              decoration: BoxDecoration(
                                color: startButtonGreen,
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                  width: 3,
                                  color: startButtonGreen,
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  "LOG IN AS GUEST",
                                  style: (startButtonText),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
