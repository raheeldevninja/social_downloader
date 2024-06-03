import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:social_downloader/core/helpers/dir_helper.dart';
import 'package:social_downloader/features/view_model/download_save_provider.dart';

class DownloadTwitterScreen extends StatefulWidget {
  const DownloadTwitterScreen({super.key});

  @override
  State<DownloadTwitterScreen> createState() => _DownloadTwitterScreenState();
}

class _DownloadTwitterScreenState extends State<DownloadTwitterScreen> {
  final _twitterVideoLinkController = TextEditingController();
  ClipboardData? _clipboardData;

  @override
  Widget build(BuildContext context) {
    final downloadSaveProvider = Provider.of<DownloadSaveProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'Download Twitter Videos',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'twitter',
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/twitter.svg',
                  height: 100,
                  width: 100,
                ),
              ),
            ),

            const SizedBox(height: 50),

            const Text(
              'Paste Twitter Video Link',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _twitterVideoLinkController,
                    decoration: InputDecoration(
                      hintText: 'Twitter video link',
                      //rounded corner border
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 1.0),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 1.0),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      suffixIcon: IconButton(
                        onPressed: _twitterVideoLinkController.text.isEmpty
                            ? null
                            : () {
                                _twitterVideoLinkController.clear();
                              },
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    //rounded corner
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    onPressed: () {
                      Clipboard.getData('text/plain').then((value) {
                        setState(() {
                          _clipboardData = value;
                          _twitterVideoLinkController.text =
                              _clipboardData?.text ?? '';
                        });
                      });
                    },
                    child: const Text('Paste'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16.0),

            //download button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                //rounded corner
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: downloadSaveProvider.isDownloading
                    ? null
                    : () async {
                        if (_twitterVideoLinkController.text.isNotEmpty) {
                          await downloadSaveProvider.getTwitterVideo(
                            context,
                            _twitterVideoLinkController.text.trim(),
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
                child: const Text('Download'),
              ),
            ),

            const SizedBox(height: 20),

            if (downloadSaveProvider.isLoading) ...[
              const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  color: Colors.black,
                ),
              ),
            ],

            if (downloadSaveProvider.isDownloading)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      value: downloadSaveProvider.progress,
                      backgroundColor: Colors.white,
                      color: Colors.black,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '${(downloadSaveProvider.progress * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<String> _getPathById(String id) async {
    final appPath = await DirHelper.getAppPath();
    return "$appPath/$id.mp4";
  }
}
