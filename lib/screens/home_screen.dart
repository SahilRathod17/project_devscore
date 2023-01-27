// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_devscore/screens/add_post_screen.dart';
import 'package:project_devscore/screens/drawer_screen.dart';
import 'package:project_devscore/utils/colors.dart';
import 'package:project_devscore/utils/global_variables.dart';
import 'package:project_devscore/widgets/post_card.dart';
import 'package:project_devscore/widgets/snackbar.dart';

class HomeScreen extends StatefulWidget {
  final String uid;
  const HomeScreen({super.key, required this.uid});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var UserData = {};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  getUserData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      UserData = userSnap.data()!;
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: width > webScreenSize
          ? null
          : AppBar(
              iconTheme: const IconThemeData(
                color: blackColor,
              ),
              centerTitle: true,
              elevation: 0,
              backgroundColor:
                  width > webScreenSize ? webBackgroundColor : primaryColor,
              actions: [
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.black, size: 30.0),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => AddPostScreen()),
                      ),
                    );
                  },
                ),
                // IconButton(
                //     onPressed: () {},
                //     icon: const Icon(
                //       EvaIcons.messageSquare,
                //       color: Colors.black,
                //     ))
              ],
              title: const Text(
                'DevsCore',
                style: TextStyle(
                  color: blueColor,
                  fontFamily: 'pacifico',
                  fontSize: 35.0,
                ),
              ),
            ),
      drawer: isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : HomePageDrawer(UserData: UserData),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return RefreshIndicator(
            color: blueColor,
            onRefresh: _refresh,
            child: ListView.builder(
              // snapshot data can not be null,
              //  so if it's null docs.length (docs - give list of id means post ids )
              // get length so only that much will be appear
              itemCount: snapshot.data!.docs.length,
              itemBuilder: ((context, index) => Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: width > webScreenSize ? width * 0.3 : 0,
                      vertical: width > webScreenSize ? 15 : 0,
                    ),
                    child: PostCard(
                      // gonna grab only one doc at a time
                      snap: snapshot.data!.docs[index].data(),
                    ),
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
