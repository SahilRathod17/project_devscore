import 'package:flutter/material.dart';
import 'package:project_devscore/screens/add_post_screen.dart';
import 'package:project_devscore/utils/colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Username',
          style: TextStyle(
              color: Colors.white, fontFamily: 'kenia', fontSize: 30.0),
        ),
        backgroundColor: mobileBackgroundColor,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_circle,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => AddPostScreen()),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
