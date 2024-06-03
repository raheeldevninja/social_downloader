import 'package:flutter/material.dart';

class DownloadingProgress extends StatefulWidget {
  const DownloadingProgress({
    required this.progress,
    super.key});

  final double progress;

  @override
  State<DownloadingProgress> createState() => _DownloadingProgressState();
}

class _DownloadingProgressState extends State<DownloadingProgress> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(
          value: widget.progress,
          backgroundColor: Colors.white,
          color: Colors.black,
        ),
        const SizedBox(height: 20),
        Text(
          '${(widget.progress * 100).toStringAsFixed(0)}%',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
