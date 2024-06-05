import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.black,
    this.icon,
  });

  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
      ),
      child: FittedBox(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon),
              const SizedBox(width: 8),
            ],
            Text(
              text,
            ),
          ],
        ),
      ),
    );
  }
}
