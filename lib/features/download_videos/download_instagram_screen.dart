import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:social_downloader/core/helpers/dir_helper.dart';
import 'package:social_downloader/core/images/images.dart';
import 'package:social_downloader/core/ui/custom_app_bar.dart';
import 'package:social_downloader/core/ui/simple_button.dart';
import 'package:social_downloader/features/download_videos/widgets/downloading_progress.dart';
import 'package:social_downloader/features/download_videos/widgets/label.dart';
import 'package:social_downloader/features/download_videos/widgets/loading_indicator.dart';
import 'package:social_downloader/features/download_videos/widgets/social_logo.dart';
import 'package:social_downloader/features/download_videos/widgets/video_link_field_paste_button.dart';
import 'package:social_downloader/features/view_model/download_save_provider.dart';

class DownloadInstagramScreen extends StatefulWidget {
  const DownloadInstagramScreen({super.key});

  @override
  State<DownloadInstagramScreen> createState() =>
      _DownloadInstagramScreenState();
}

class _DownloadInstagramScreenState extends State<DownloadInstagramScreen> {
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
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            const SocialLogo(
              tag: 'instagram',
              logoPath: Images.instagramImage,
              width: 100,
              height: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 50),
            const Label(text: 'Paste Instagram Video Link'),
            const SizedBox(height: 10),
            const VideoLinkFieldPasteButton(hintText: 'Instagram video link'),
            const SizedBox(height: 16.0),
            //download button
            SimpleButton(
              text: 'Download',
              onPressed: downloadSaveProvider.isLoading ||
                      downloadSaveProvider.isDownloading
                  ? null
                  : () async {
                      if (downloadSaveProvider.getVideoLink.isNotEmpty) {
                        await downloadSaveProvider.getInstagramVideo(
                          context,
                          downloadSaveProvider.getVideoLink.trim(),
                        );

                        final path = await _getPathById(
                            '${DateTime.now().millisecondsSinceEpoch}');

                        final tempPath = await getTemporaryDirectory();

                        //append file name
                        final file = File(
                            '${tempPath.path}/${DateTime.now().millisecondsSinceEpoch}.mp4');

                        print('new file path: ${file.path}');

                        await downloadSaveProvider.downloadInstagramVideo(
                          context,
                          downloadSaveProvider.media,
                          //path,
                          file.path,
                        );

                        await GallerySaver.saveVideo(file.path);
                      }
                    },
            ),
            const SizedBox(height: 20),
            if (downloadSaveProvider.isLoading)
              const LoadingIndicator(),

            if (downloadSaveProvider.isDownloading)
              DownloadingProgress(progress: downloadSaveProvider.progress),
          ],
        ),
      ),
    );
  }

  Future<String> _getPathById(String id) async {
    final appPath = await DirHelper.getAppPath();
    return "$appPath/$id.mp4";
  }

  _clearVideoLink() {
    final downloadSaveProvider =
        Provider.of<DownloadSaveProvider>(context, listen: false);
    downloadSaveProvider.setVideoLink('');
  }
}
