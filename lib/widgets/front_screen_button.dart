// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FrontPageButton extends StatelessWidget {
  final Icon icon;
  VoidCallback? onTap;
  FrontPageButton({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: icon,
        width: 60.0,
        height: 40.0,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
