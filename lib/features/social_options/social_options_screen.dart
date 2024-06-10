import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:social_downloader/core/helpers/helper_functions.dart';
import 'package:social_downloader/core/helpers/permissions_helper.dart';
import 'package:social_downloader/core/ui/app_drawer.dart';
import 'package:social_downloader/features/social_options/widgets/download_instagram_button.dart';
import 'package:social_downloader/features/social_options/widgets/download_tiktok_button.dart';
import 'package:social_downloader/features/social_options/widgets/download_twitter_button.dart';
import 'package:social_downloader/features/social_options/widgets/previously_downloaded_button.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class SocialOptionsScreen extends StatefulWidget {
  const SocialOptionsScreen({super.key});

  @override
  State<SocialOptionsScreen> createState() => _SocialOptionsScreenState();
}

class _SocialOptionsScreenState extends State<SocialOptionsScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late final WebViewController controller;

  String username = '';
  String email = '';

  @override
  void initState() {
    super.initState();

    _permission();
    _getUserData();

    createWebView();
  }

  void createWebView() async {
    controller = WebViewController();
    // 1. Enable JavaScript in the web view.
    await controller.setJavaScriptMode(JavaScriptMode.unrestricted);

    // 2. Enable third-party cookies for Android.
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewCookieManager cookieManager = AndroidWebViewCookieManager(
          const PlatformWebViewCookieManagerCreationParams());
      await cookieManager.setAcceptThirdPartyCookies(
          controller.platform as AndroidWebViewController, true);
    }

    // 3. Register the web view.
    await MobileAds.instance.registerWebView(controller);

    //4. load url
    await controller
        .loadRequest(Uri.parse('https://webview-api-for-ads-test.glitch.me/'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(username: username, email: email),
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
        title: const Text(
          'Social Options',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
      bottomNavigationBar: SizedBox(
        width: double.maxFinite,
        height: 30,
        child: WebViewWidget(controller: controller),
      ),
    );
  }

  _permission() async {
    bool checkPermissions = await PermissionsHelper.checkPermission();

    if (!checkPermissions) {
      log('you don\'t have permission');
    }
  }

  _getUserData() async {
    await HelperFunctions.getUsernameFromSharedPref().then((value) {
      setState(() {
        username = value;
      });
    });

    await HelperFunctions.getUserEmailFromSharedPref().then((value) {
      setState(() {
        email = value;
      });
    });

  }

}
