import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:social_downloader/core/helpers/ad_mob_service.dart';
import 'package:social_downloader/core/helpers/helper_functions.dart';
import 'package:social_downloader/core/helpers/permissions_helper.dart';
import 'package:social_downloader/core/ui/app_drawer.dart';
import 'package:social_downloader/features/auth/auth_provider.dart';
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
  final _scaffoldKey = GlobalKey<ScaffoldState>();


  String username = '';
  String email = '';

  BannerAd? _bannerAdTop;
  BannerAd? _bannerAdBottom;

  @override
  void initState() {
    super.initState();

    _permission();
    _getUserData();

    _createBannerAdTop();
    _createBannerAdBottom();
  }

  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(parentContext: context, username: username, email: email),
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
        child: authProvider.getIsLoading ? const CircularProgressIndicator(color: Colors.black) :

        Container(
          //padding: const EdgeInsets.all(24.0),
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
          child: ListView(
            children: [

              _bannerAdTop == null ? const SizedBox() : SizedBox(
                width: _bannerAdTop!.size.width.toDouble(),
                height: _bannerAdTop!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAdTop!),
              ),

              const Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
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

            ],
          ),
        ),
      ),
      bottomNavigationBar: _bannerAdBottom == null ? const SizedBox() : SizedBox(
        width: _bannerAdBottom!.size.width.toDouble(),
        height: _bannerAdBottom!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAdBottom!),
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

  _createBannerAdTop() {
    _bannerAdTop = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdMobService.bannerAdUnitId,
      request: const AdRequest(),
      listener: AdMobService.bannerAdListener,
    )..load();

    _bannerAdTop!.load();
  }

  _createBannerAdBottom() {
    _bannerAdBottom = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdMobService.bannerAdUnitId,
      request: const AdRequest(),
      listener: AdMobService.bannerAdListener,
    )..load();

    _bannerAdBottom!.load();
  }

}
