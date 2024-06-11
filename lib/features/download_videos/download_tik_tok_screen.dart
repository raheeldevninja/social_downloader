import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:social_downloader/core/helpers/ad_mob_service.dart';
import 'package:social_downloader/core/images/images.dart';
import 'package:social_downloader/core/ui/custom_app_bar.dart';
import 'package:social_downloader/core/ui/simple_button.dart';
import 'package:social_downloader/core/utils/utils.dart';
import 'package:social_downloader/features/download_videos/widgets/downloading_progress.dart';
import 'package:social_downloader/features/download_videos/widgets/label.dart';
import 'package:social_downloader/features/download_videos/widgets/loading_indicator.dart';
import 'package:social_downloader/features/download_videos/widgets/social_logo.dart';
import 'package:social_downloader/features/download_videos/widgets/video_link_field_paste_button.dart';
import 'package:social_downloader/features/view_model/download_save_provider.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class DownloadTikTokScreen extends StatefulWidget {
  const DownloadTikTokScreen({super.key});

  @override
  State<DownloadTikTokScreen> createState() => _DownloadTikTokScreenState();
}

class _DownloadTikTokScreenState extends State<DownloadTikTokScreen> {

  BannerAd? _bannerAdTop;
  BannerAd? _bannerAdBottom;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _clearVideoLink();

      _createBannerAdTop();
      _createBannerAdBottom();

    });
  }

  @override
  Widget build(BuildContext context) {
    final downloadSaveProvider = Provider.of<DownloadSaveProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const CustomAppBar(title: 'Download TikTok Videos'),
      body: Container(

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xA6FF0050),
              Color(0xA6FF0050),
              Color(0xA600F2EA),
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

            ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(24.0),
              children: [

                const SocialLogo(
                  tag: 'tiktok',
                  logoPath: Images.tiktokImage,
                ),
                const SizedBox(height: 50),
                const Label(text: 'Paste TikTok Video Link'),
                const SizedBox(height: 10),
                const VideoLinkFieldPasteButton(hintText: 'TikTok video link'),
                const SizedBox(height: 16.0),
                //download button
                SimpleButton(
                  text: 'Download',
                  onPressed: downloadSaveProvider.isLoading ||
                      downloadSaveProvider.isDownloading
                      ? null
                      : () async {

                    //check internet connection
                    bool isInternetConnected = await Utils.checkInternetConnection();

                    if (!isInternetConnected) {
                      Utils.showCustomSnackBar(
                        context,
                        'Not connected to internet',
                        ContentType.failure,
                      );

                      return;
                    }

                    if (downloadSaveProvider.getVideoLink.isNotEmpty) {

                      //1. get tiktok video details
                      await downloadSaveProvider.getTikTokVideo(
                        context,
                        downloadSaveProvider.getVideoLink.trim(),
                      );

                      if(downloadSaveProvider.linkrwm.isNotEmpty) {

                        //2
                        final tempPath = await getTemporaryDirectory();

                        //append file name
                        final file = File(
                            '${tempPath.path}/${DateTime.now().millisecondsSinceEpoch}.mp4');

                        print('file path: ${file.path}');

                        //3. download tiktok video
                        if (context.mounted) {
                          await downloadSaveProvider.downloadTikTokVideo(
                            context,
                            downloadSaveProvider.linkrwm,
                            file.path,
                          );
                        }

                      }



                    }
                  },
                ),
                const SizedBox(height: 20),

                if (downloadSaveProvider.isLoading) const LoadingIndicator(),

                if (downloadSaveProvider.isDownloading)
                  DownloadingProgress(progress: downloadSaveProvider.progress),


              ],
            ),


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
