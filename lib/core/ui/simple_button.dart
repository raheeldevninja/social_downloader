import 'package:flutter/material.dart';

class SimpleButton extends StatelessWidget {
  const SimpleButton({
    required this.text,
    required this.onPressed,
    super.key});

  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
