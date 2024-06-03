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
    // TODO: implement initState
    super.initState();

    _permission();
  }

  _permission() async {
    bool checkPermissions = await PermissionsHelper.checkPermission();

    if (!checkPermissions) {
      print('you dont have permission ');
    }
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
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
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
}
