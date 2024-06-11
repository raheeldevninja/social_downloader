import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:social_downloader/core/helpers/helper_functions.dart';
import 'package:social_downloader/features/auth/login_screen.dart';
import 'package:social_downloader/features/social_options/social_options_screen.dart';
import 'package:social_downloader/features/view_model/download_save_provider.dart';
import 'package:social_downloader/firebase_options.dart';

import 'features/auth/auth_provider.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DownloadSaveProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();

    _getUserLoggedInStatus();
  }

  _getUserLoggedInStatus() async {

    HelperFunctions.getUserLoggedInStatus().then((value) {
      setState(() {
        _isSignedIn = value;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SaveInsta',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: _isSignedIn ? const SocialOptionsScreen() : const LoginScreen(),
    );
  }
}
