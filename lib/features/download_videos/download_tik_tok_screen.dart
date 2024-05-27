import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DownloadTikTokScreen extends StatefulWidget {
  const DownloadTikTokScreen({super.key});

  @override
  State<DownloadTikTokScreen> createState() => _DownloadTikTokScreenState();
}

class _DownloadTikTokScreenState extends State<DownloadTikTokScreen> {

  final _tikTokVideoLinkController = TextEditingController();
  ClipboardData? _clipboardData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'Download TikTok Videos',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Text(
                'Paste TikTok Video Link',
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
                      controller: _tikTokVideoLinkController,
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
                      onPressed: () async {

                        _clipboardData = await Clipboard.getData('text/plain');
                        setState(() {
                          _tikTokVideoLinkController.text = _clipboardData!.text.toString();
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
                  onPressed: () {},
                  child: const Text('Download'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
