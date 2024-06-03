import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';

class PreviouslyDownloadedButton extends StatelessWidget {
  const PreviouslyDownloadedButton({super.key});

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
        onPressed: () async {

          const intent = AndroidIntent(
            action: 'action_view',
            type: 'video/*',
            flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
          );

          intent.launch();

        },
        icon: const Icon(Icons.download),
        label: const Text(
          'Previously Downloaded',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
