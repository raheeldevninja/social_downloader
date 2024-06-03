import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_downloader/features/download_videos/download_instagram_screen.dart';

class DownloadInstagramButton extends StatelessWidget {
  const DownloadInstagramButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
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
              builder: (context) => const DownloadInstagramScreen(),
            ),
          );
        },
        icon: Hero(
          tag: 'instagram',
          child: SvgPicture.asset(
            width: 40,
            height: 40,
            'assets/icons/instagram.svg',
            color: Colors.white,
          ),
        ),
        label: const Text(
          'Download Instagram Videos',
          style: TextStyle(
            fontSize: 16,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
