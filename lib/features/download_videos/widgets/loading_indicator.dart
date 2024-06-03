import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        SizedBox(height: 20),
        Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.white,
            color: Colors.black,
          ),
        ),

      ],
    );
  }
}
