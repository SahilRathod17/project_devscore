// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class policyText extends StatelessWidget {
  const policyText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "By continuing you agree DevsCore's Terms of",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12.0),
            ),
            Text(
              "Services & Privacy Policy",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12.0),
            ),
          ],
        ),
      ),
    );
  }
}
