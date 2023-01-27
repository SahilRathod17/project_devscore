import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      dismissDirection: DismissDirection.horizontal,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      behavior: SnackBarBehavior.floating,
      content: Text(text),
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 100,
      ),
    ),
  );
}
