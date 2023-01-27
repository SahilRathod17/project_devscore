import 'package:flutter/material.dart';

Column buildStateColumn(int num, String label) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        num.toString(),
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
      ),
      Container(
        margin: const EdgeInsets.only(top: 4.0),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
      ),
    ],
  );
}
