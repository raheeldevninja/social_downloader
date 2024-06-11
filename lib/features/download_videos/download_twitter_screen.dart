import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:social_downloader/core/helpers/ad_mob_service.dart';
import 'package:social_downloader/core/ui/custom_app_bar.dart';
import 'package:social_downloader/features/download_videos/widgets/download_twitter_main_content.dart';
import 'package:social_downloader/features/view_model/download_save_provider.dart';


class DownloadTwitterScreen extends StatefulWidget {
  const DownloadTwitterScreen({super.key});

  @override
  State<DownloadTwitterScreen> createState() => _DownloadTwitterScreenState();
}

class _DownloadTwitterScreenState extends State<DownloadTwitterScreen> {

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
      appBar: const CustomAppBar(title: 'Download Twitter Videos'),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [

              Color(0xFF1DA1F2),
              Color(0xFF1DA1F2),
              Color(0x401DA1F2),

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

            const DownloadTwitterMainContent(),

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
