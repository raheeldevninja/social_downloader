import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_downloader/core/helpers/dir_helper.dart';
import 'package:social_downloader/core/helpers/permissions_helper.dart';
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
              logoPath: 'assets/icons/tiktok.svg',
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
                        /*bool checkPermissions =
                      await PermissionsHelper.checkPermission();

                  if (!checkPermissions) {
                    return;
                  }*/

                        /*final appPath = await DirHelper.getAppPath();

                  downloadSaveProvider.downloadTikTokVideo(
                    _tikTokVideoLinkController.text.trim(),
                    '$appPath/${DateTime.now().millisecondsSinceEpoch}.mp4',
                  );*/

                        await downloadSaveProvider.getTikTokVideo(
                          context,
                          downloadSaveProvider.getVideoLink.trim(),
                        );

                        final path =
                            await _getPathById(downloadSaveProvider.id);

                        if (context.mounted) {
                          await downloadSaveProvider.downloadTikTokVideo(
                            context,
                            downloadSaveProvider.linkrwm,
                            path,
                          );
                        }
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
    final downloadSaveProvider = Provider.of<DownloadSaveProvider>(context, listen: false);
    downloadSaveProvider.setVideoLink('');
  }

}
