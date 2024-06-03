import 'package:flutter/material.dart';
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

class DownloadTwitterScreen extends StatefulWidget {
  const DownloadTwitterScreen({super.key});

  @override
  State<DownloadTwitterScreen> createState() => _DownloadTwitterScreenState();
}

class _DownloadTwitterScreenState extends State<DownloadTwitterScreen> {
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
      appBar: const CustomAppBar(title: 'Download Twitter Videos'),
      body: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: ListView(
          children: [
            const SocialLogo(
              tag: 'twitter',
              logoPath: Images.twitterImage,
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 50),
            const Label(text: 'Paste Twitter Video Link'),
            const SizedBox(height: 10),
            const VideoLinkFieldPasteButton(hintText: 'Twitter video link'),
            const SizedBox(height: 16.0),
            //download button
            SimpleButton(
              text: 'Download',
              onPressed: downloadSaveProvider.isLoading ||
                      downloadSaveProvider.isDownloading
                  ? null
                  : () async {
                      if (downloadSaveProvider.getVideoLink.isNotEmpty) {
                        await downloadSaveProvider.getTwitterVideo(
                          context,
                          downloadSaveProvider.getVideoLink.trim(),
                        );

                        final path = await _getPathById(
                            '${DateTime.now().millisecondsSinceEpoch}');

                        await downloadSaveProvider.downloadTwitterVideo(
                          context,
                          downloadSaveProvider.media,
                          path,
                        );
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
