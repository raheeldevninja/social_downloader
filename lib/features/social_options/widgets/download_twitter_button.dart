import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_downloader/core/images/images.dart';
import 'package:social_downloader/features/download_videos/download_twitter_screen.dart';

class DownloadTwitterButton extends StatelessWidget {
  const DownloadTwitterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.black,
      ),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DownloadTwitterScreen(),
            ),
          );
        },
        icon: Hero(
          tag: 'twitter',
          child: SvgPicture.asset(
            width: 40,
            height: 40,
            Images.twitterImage,
            color: Colors.white,
          ),
        ),
        label: const Text(
          'Download Twitter Videos',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
