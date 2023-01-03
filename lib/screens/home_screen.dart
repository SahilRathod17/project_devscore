import 'package:flutter/material.dart';
import 'package:project_devscore/screens/add_post_screen.dart';
import 'package:project_devscore/utils/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text(
          'DevsCore',
          style: TextStyle(
            fontFamily: 'kenia',
            fontSize: 35.0,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.add_circle,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: ((context) => const AddPostScreen()),
              ),
            );
          },
        ),
      ),
    );
  }
}
