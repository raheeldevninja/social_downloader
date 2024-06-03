import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:social_downloader/core/ui/simple_button.dart';
import 'package:social_downloader/features/view_model/download_save_provider.dart';

class VideoLinkFieldPasteButton extends StatefulWidget {
  const VideoLinkFieldPasteButton({required this.hintText, super.key});

  final String hintText;

  @override
  State<VideoLinkFieldPasteButton> createState() =>
      _VideoLinkFieldPasteButtonState();
}

class _VideoLinkFieldPasteButtonState extends State<VideoLinkFieldPasteButton> {

  final _videoLinkController = TextEditingController();
  ClipboardData? _clipboardData;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final downloadSaveProvider = Provider.of<DownloadSaveProvider>(context);

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _videoLinkController,
            onChanged: (value) {
              downloadSaveProvider.setVideoLink(value);
            },
            decoration: InputDecoration(
              hintText: 'TikTok video link',
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
                onPressed: _videoLinkController.text.isEmpty
                    ? null
                    : () {
                        _videoLinkController.clear();
                        downloadSaveProvider.setVideoLink('');
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
        SimpleButton(
          text: 'Paste',
          onPressed: () async {
            _clipboardData = await Clipboard.getData('text/plain');

            //set video link
            downloadSaveProvider.setVideoLink(_clipboardData!.text.toString());

            setState(() {
              _videoLinkController.text = _clipboardData!.text.toString();
            });
          },
        ),
      ],
    );
  }

  @override
  dispose() {
    _videoLinkController.dispose();
    super.dispose();
  }

}
