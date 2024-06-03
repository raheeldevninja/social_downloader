import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:social_downloader/core/ui/custom_app_bar.dart';
import 'package:social_downloader/core/ui/input_decoration.dart';
import 'package:social_downloader/core/ui/simple_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Login', shouldShowBack: false,),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 80),
        children: [
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
              prefixIcon: const Icon(Icons.email),
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
              prefixIcon: const Icon(Icons.lock),
              prefixIconColor: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          SimpleButton(
            text: 'Login',
            onPressed: () {
              //login();
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
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
