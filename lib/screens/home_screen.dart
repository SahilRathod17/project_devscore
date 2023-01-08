import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:project_devscore/screens/add_post_screen.dart';
import 'package:project_devscore/utils/colors.dart';
import 'package:project_devscore/widgets/post_card.dart';

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
          IconButton(
              onPressed: () {},
              icon: const Icon(
                EvaIcons.messageSquare,
                color: Colors.white,
              ))
        ],
        title: const Text(
          'DevsCore',
          style: TextStyle(
            fontFamily: 'kenia',
            fontSize: 35.0,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return RefreshIndicator(
            color: Colors.white,
            onRefresh: _refresh,
            child: ListView.builder(
              // snapshot data can not be null,
              //  so if it's null docs.length (docs - give list of id means post ids )
              // get length so only that much will be appear
              itemCount: snapshot.data!.docs.length,
              itemBuilder: ((context, index) => PostCard(
                    // gonna grab only one doc at a time
                    snap: snapshot.data!.docs[index].data(),
                  )),
            ),
          );
        },
      ),
    );
  }

  Future<void> _refresh() {
    return Future.delayed(
      const Duration(seconds: 1),
    );
  }
}
