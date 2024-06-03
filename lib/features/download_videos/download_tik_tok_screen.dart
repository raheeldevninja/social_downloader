import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:social_downloader/core/helpers/permissions_helper.dart';
import 'package:social_downloader/core/images/images.dart';
import 'package:social_downloader/core/ui/custom_app_bar.dart';
import 'package:social_downloader/core/ui/simple_button.dart';
import 'package:social_downloader/features/download_videos/widgets/downloading_progress.dart';
import 'package:social_downloader/features/download_videos/widgets/label.dart';
import 'package:social_downloader/features/download_videos/widgets/loading_indicator.dart';
import 'package:social_downloader/features/download_videos/widgets/social_logo.dart';
import 'package:social_downloader/features/download_videos/widgets/video_link_field_paste_button.dart';
import 'package:social_downloader/features/view_model/download_save_provider.dart';

class DownloadTikTokScreen extends StatefulWidget {
  const DownloadTikTokScreen({super.key});

  @override
  State<DownloadTikTokScreen> createState() => _DownloadTikTokScreenState();
}

class _DownloadTikTokScreenState extends State<DownloadTikTokScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _clearVideoLink();
    });
  }

  @override
  Widget build(BuildContext context) {
    final downloadSaveProvider = Provider.of<DownloadSaveProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const CustomAppBar(title: 'Download TikTok Videos'),
      body: Container(
        padding: const EdgeInsets.all(24.0),
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
        child: ListView(
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
                      if (downloadSaveProvider.getVideoLink.isNotEmpty) {

                        //1. get tiktok video details
                        await downloadSaveProvider.getTikTokVideo(
                          context,
                          downloadSaveProvider.getVideoLink.trim(),
                        );

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
                    },
            ),
            const SizedBox(height: 20),

            if (downloadSaveProvider.isLoading) const LoadingIndicator(),

            if (downloadSaveProvider.isDownloading)
              DownloadingProgress(progress: downloadSaveProvider.progress),
          ],
        ),
      ),
    );
  }

  _clearVideoLink() {
    final downloadSaveProvider =
        Provider.of<DownloadSaveProvider>(context, listen: false);
    downloadSaveProvider.setVideoLink('');
  }
}
