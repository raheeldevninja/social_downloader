import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialLogo extends StatelessWidget {
  const SocialLogo({
    required this.tag,
    required this.logoPath,
    this.color,
    this.width = 130,
    this.height = 130,
    super.key});

  final Object tag;
  final String logoPath;
  final Color? color;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: Center(
        child: SvgPicture.asset(
          logoPath,
          width: width,
          height: height,
          color: color,
        ),
      ),
    );
  }
}
