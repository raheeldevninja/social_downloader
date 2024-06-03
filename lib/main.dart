import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_downloader/features/social_options/social_options_screen.dart';
import 'package:social_downloader/features/view_model/download_save_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DownloadSaveProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Social Downloader',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SocialOptionsScreen(),
    );
  }
}
