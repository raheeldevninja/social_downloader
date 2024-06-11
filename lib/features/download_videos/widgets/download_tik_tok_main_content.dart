import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:social_downloader/core/images/images.dart';
import 'package:social_downloader/core/ui/simple_button.dart';
import 'package:social_downloader/core/utils/utils.dart';
import 'package:social_downloader/features/download_videos/widgets/downloading_progress.dart';
import 'package:social_downloader/features/download_videos/widgets/label.dart';
import 'package:social_downloader/features/download_videos/widgets/loading_indicator.dart';
import 'package:social_downloader/features/download_videos/widgets/social_logo.dart';
import 'package:social_downloader/features/download_videos/widgets/video_link_field_paste_button.dart';
import 'package:social_downloader/features/view_model/download_save_provider.dart';

class DownloadTikTokMainContent extends StatefulWidget {
  const DownloadTikTokMainContent({super.key});

  @override
  State<DownloadTikTokMainContent> createState() => _DownloadTikTokMainContentState();
}

class _DownloadTikTokMainContentState extends State<DownloadTikTokMainContent> {

  @override
  Widget build(BuildContext context) {

    final downloadSaveProvider = Provider.of<DownloadSaveProvider>(context);

    return ListView(
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
    );
  }
}
