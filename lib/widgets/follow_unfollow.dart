// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final Function()? fun;
  final Color backgroundColor;
  final Color borderColor;
  final String text;
  final Color textColor;
  const FollowButton(
      {super.key,
      this.fun,
      required this.backgroundColor,
      required this.borderColor,
      required this.text,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 2.0),
      child: TextButton(
          onPressed: fun,
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(
                color: borderColor,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w400,
              ),
            ),
            width: MediaQuery.of(context).size.width * 0.6,
            height: 27,
          )),
    );
  }
}
