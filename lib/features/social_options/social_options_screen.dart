import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:social_downloader/core/helpers/permissions_helper.dart';
import 'package:social_downloader/features/social_options/widgets/download_instagram_button.dart';
import 'package:social_downloader/features/social_options/widgets/download_tiktok_button.dart';
import 'package:social_downloader/features/social_options/widgets/download_twitter_button.dart';
import 'package:social_downloader/features/social_options/widgets/previously_downloaded_button.dart';

class SocialOptionsScreen extends StatefulWidget {
  const SocialOptionsScreen({super.key});

  @override
  State<SocialOptionsScreen> createState() => _SocialOptionsScreenState();
}

class _SocialOptionsScreenState extends State<SocialOptionsScreen> {
  @override
  void initState() {
    super.initState();

    _permission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Social Options',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFFFFF),
                Color(0xA15851DB),
                Color(0xA15851DB),
                Color(0xFF5851DB),
                Color(0xFF405DE6),
              ],
            ),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              //download tiktok button
              DownloadTiktokButton(),
              SizedBox(height: 8),
              //instagram button
              DownloadInstagramButton(),
              SizedBox(height: 8),
              //twitter button
              DownloadTwitterButton(),
              SizedBox(height: 8),
              //previously downloaded button
              PreviouslyDownloadedButton(),

            ],
          ),
        ),
      ),
    );
  }

  _permission() async {
    bool checkPermissions = await PermissionsHelper.checkPermission();

    if (!checkPermissions) {
      log('you don\'t have permission');
    }
  }

}
