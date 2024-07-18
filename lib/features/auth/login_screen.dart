import 'dart:developer';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:social_downloader/core/helpers/helper_functions.dart';
import 'package:social_downloader/core/images/images.dart';
import 'package:social_downloader/core/ui/custom_app_bar.dart';
import 'package:social_downloader/core/ui/input_decoration.dart';
import 'package:social_downloader/core/ui/simple_button.dart';
import 'package:social_downloader/core/utils/utils.dart';
import 'package:social_downloader/features/auth/register_screen.dart';
import 'package:social_downloader/features/auth/services/auth_service.dart';
import 'package:social_downloader/features/auth/services/database_service.dart';
import 'package:social_downloader/features/social_options/social_options_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';

  bool _isLoading = false;
  bool _obscureText = true;

  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Login',
        shouldShowBack: false,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.black),
            )
          : Form(
            key: _formKey,
            child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 80),
                children: [

                  Image.asset(Images.logo, width: 140, height: 140),

                  const SizedBox(height: 20),

                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (val) {
                      setState(() {
                        email = val;
                      });
                    },
                    validator: (val) {
                      return RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(val!)
                          ? null
                          : "Please enter a valid email";
                    },
                    decoration: textInputDecoration.copyWith(
                      label: const Text('Email'),
                      prefixIcon: const Icon(Icons.email, color: Colors.black),
                      prefixIconColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    obscureText: _obscureText,
                    onChanged: (val) {
                      setState(() {
                        password = val;
                      });
                    },
                    validator: (val) {
                      return val!.length < 6
                          ? "Password must be at least 6 characters"
                          : null;
                    },
                    decoration: textInputDecoration.copyWith(
                      label: const Text('Password'),
                      prefixIcon: const Icon(Icons.lock, color: Colors.black),
                      prefixIconColor: Theme.of(context).primaryColor,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SimpleButton(
                    text: 'Login',
                    onPressed: _isLoading ? null : () {
                      _login();
                    },
                  ),
                  const SizedBox(height: 16),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'Don\'t have an account? ',
                      style: const TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: 'Register Here',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ),
                            );

                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ),
    );
  }

  _login() {

    if (_formKey.currentState!.validate()) {

      setState(() {
        _isLoading = true;
      });

      _authService
          .signInUserWithEmailAndPassword(email, password)
          .then((value) async {

            try {

              if (value == true) {

                QuerySnapshot snapshot =
                await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                    .getUserData(email);


                //save values to shared preferences
                await HelperFunctions.saveUsername(snapshot.docs[0].get('fullName'));
                await HelperFunctions.saveUserEmail(snapshot.docs[0].get('email'));
                await HelperFunctions.saveUserLoggedInStatus(true);

                if (mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SocialOptionsScreen(),
                    ),
                  );
                }
              } else {
                Utils.showCustomSnackBar(context, value, ContentType.failure);

                setState(() {
                  _isLoading = false;
                });
              }


            }catch(e) {

              setState(() {
                _isLoading = false;
              });

              log('error: $e');

              Utils.showCustomSnackBar(context, e.toString(), ContentType.failure);
            }


      });

    }
  }
}
