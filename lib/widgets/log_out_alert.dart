import 'package:flutter/material.dart';
import 'package:project_devscore/widgets/log_out_button.dart';

class LogOutAlert extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onPressed;
  LogOutAlert({required this.content, required this.title,required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(
        content,
        style: const TextStyle(fontSize: 15),
      ),
      actions: [
        LogOutButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            text: 'No'),
        LogOutButton(
          text: 'Yes',
          onPressed: onPressed,
        )
      ],
    );
  }
}
