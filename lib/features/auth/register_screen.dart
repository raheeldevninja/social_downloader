import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:social_downloader/core/helpers/helper_functions.dart';
import 'package:social_downloader/core/ui/custom_app_bar.dart';
import 'package:social_downloader/core/ui/input_decoration.dart';
import 'package:social_downloader/core/ui/simple_button.dart';
import 'package:social_downloader/core/utils/utils.dart';
import 'package:social_downloader/features/auth/services/auth_service.dart';
import 'package:social_downloader/features/social_options/social_options_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  String fullName = '';
  String email = '';
  String password = '';

  bool _isLoading = false;

  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Register',
        shouldShowBack: true,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ))
          : Form(
        key: _formKey,
            child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 80),
                children: [
                  TextFormField(
                    keyboardType: TextInputType.text,
                    onChanged: (val) {
                      setState(() {
                        fullName = val;
                      });
                    },
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Please enter your full name";
                      } else {
                        return null;
                      }
                    },
                    decoration: textInputDecoration.copyWith(
                      label: const Text('Full Name'),
                      prefixIcon: const Icon(Icons.person, color: Colors.black),
                      prefixIconColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
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
                    obscureText: true,
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
                    ),
                  ),
                  const SizedBox(height: 20),
                  SimpleButton(
                    text: 'Register',
                    onPressed: () {
                      _register();
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: const TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: 'Login Now',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pop(context);
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

  _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      _authService
          .registerUserWithEmailAndPassword(fullName, email, password)
          .then((value) async {
        if (value == true) {
          //save data to shared preferences
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUsername(fullName);
          await HelperFunctions.saveUserEmail(email);

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
      });
    }
  }
}
