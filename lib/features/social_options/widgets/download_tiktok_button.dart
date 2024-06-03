import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_downloader/features/download_videos/download_tik_tok_screen.dart';

class DownloadTiktokButton extends StatelessWidget {
  const DownloadTiktokButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 80,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                  color: Color(0xFF00F2EA),
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 80,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  color: Color(0xFFFF0050),
                ),
              ),
            ),
          ],
        ),
        Container(
          width: double.maxFinite,
          height: 80,
          margin: const EdgeInsets.only(left: 8, right: 8),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.white,
          ),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DownloadTikTokScreen(),
                ),
              );
            },
            icon: Hero(
              tag: 'tiktok',
              child: SvgPicture.asset(
                width: 60,
                height: 60,
                'assets/icons/tiktok.svg',
                color: Colors.black,
              ),
            ),
            label: const Text(
              'Download TikTok Videos',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
