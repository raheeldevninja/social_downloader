import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:social_downloader/core/helpers/ad_mob_service.dart';
import 'package:social_downloader/core/ui/custom_app_bar.dart';
import 'package:social_downloader/features/download_videos/widgets/download_instagram_main_content.dart';
import 'package:social_downloader/features/view_model/download_save_provider.dart';

class DownloadInstagramScreen extends StatefulWidget {
  const DownloadInstagramScreen({super.key});

  @override
  State<DownloadInstagramScreen> createState() =>
      _DownloadInstagramScreenState();
}

class _DownloadInstagramScreenState extends State<DownloadInstagramScreen> {

  BannerAd? _bannerAdTop;
  BannerAd? _bannerAdBottom;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _clearVideoLink();

      _createBannerAdTop();
      _createBannerAdBottom();

      setState(() {});

    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const CustomAppBar(title: 'Download Instagram Videos'),
      body: Container(
        //instagram gradient color
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF405DE6),
              Color(0xFF5851DB),
              Color(0xFF833AB4),
              Color(0xFFC13584),
              Color(0xFFE1306C),
              Color(0xFFFD1D1D),
            ],
          ),
        ),
        child: Column(
          children: [

            _bannerAdTop == null ? const SizedBox() : SizedBox(
              width: _bannerAdTop!.size.width.toDouble(),
              height: _bannerAdTop!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAdTop!),
            ),

            const DownloadInstagramMainContent(),

          ],
        ),
      ),
      bottomNavigationBar: _bannerAdBottom == null ? const SizedBox() : SizedBox(
        width: _bannerAdBottom!.size.width.toDouble(),
        height: _bannerAdBottom!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAdBottom!),
      ),
    );
  }

  _clearVideoLink() {
    final downloadSaveProvider =
        Provider.of<DownloadSaveProvider>(context, listen: false);
    downloadSaveProvider.setVideoLink('');
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
