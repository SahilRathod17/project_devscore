import 'package:flutter/material.dart';

class LogOutButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  const LogOutButton({Key? key, required this.onPressed, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
