// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_devscore/screens/add_post_screen.dart';
import 'package:project_devscore/screens/login_screen.dart';
import 'package:project_devscore/services/auth_methods.dart';
import 'package:project_devscore/services/firestore_methods.dart';
import 'package:project_devscore/utils/colors.dart';
import 'package:project_devscore/widgets/buildstatecolumn.dart';
import 'package:project_devscore/widgets/follow_unfollow.dart';
import 'package:project_devscore/widgets/log_out_alert.dart';
import 'package:project_devscore/widgets/post_card.dart';
import 'package:project_devscore/widgets/snackbar.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var UserData = {};
  int noOfPosts = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
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

      // getting no of posts user has
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      noOfPosts = postSnap.docs.length;
      UserData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);

      setState(() {});
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator.adaptive(),
          )
        : Scaffold(
            backgroundColor: primaryColor,
            appBar: AppBar(
              iconTheme: const IconThemeData(color: blackColor),
              leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back_ios_new_rounded)),
              title: Text(
                UserData['username'.trim()],
                style: const TextStyle(
                    color: blackColor, fontFamily: 'kenia', fontSize: 30.0),
              ),
              centerTitle: false,
              backgroundColor: primaryColor,
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.add_circle,
                    color: Colors.black,
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
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(UserData['photoUrl']),
                            radius: 40.0,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStateColumn(noOfPosts, 'Posts'),
                                    buildStateColumn(followers, 'Followers'),
                                    buildStateColumn(following, 'Following'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FirebaseAuth.instance.currentUser!.uid ==
                                            widget.uid
                                        ? FollowButton(
                                            text: "Sign Out",
                                            backgroundColor: blueColor,
                                            textColor: primaryColor,
                                            borderColor: Colors.grey,
                                            fun: () {
                                              showDialog(
                                                context: context,
                                                builder: ((context) {
                                                  return LogOutAlert(
                                                    title: 'Logout',
                                                    content:
                                                        'Are your sure you want to logout ?',
                                                    onPressed: () async {
                                                      await AuthMethods()
                                                          .SignOut();
                                                      // ignore: use_build_context_synchronously
                                                      Navigator.of(context)
                                                          .pushReplacement(
                                                        MaterialPageRoute(
                                                          builder: ((context) =>
                                                              LoginScreen()),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }),
                                              );
                                            },
                                          )
                                        : isFollowing
                                            ? FollowButton(
                                                text: "Unfollow",
                                                backgroundColor:
                                                    Colors.transparent,
                                                textColor: blackColor,
                                                borderColor: Colors.grey,
                                                fun: () async {
                                                  await FireStoreMethods()
                                                      .FollowUsers(
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid,
                                                          UserData['uid']);
                                                  setState(() {
                                                    // we are not using stream here so it will take data only one time we'll manage that data manually
                                                    isFollowing = false;
                                                    followers--;
                                                  });
                                                },
                                              )
                                            : FollowButton(
                                                text: "Follow",
                                                backgroundColor:
                                                    Colors.blueAccent,
                                                textColor: Colors.white,
                                                borderColor: Colors.grey,
                                                fun: () async {
                                                  await FireStoreMethods()
                                                      .FollowUsers(
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid,
                                                          UserData['uid']);
                                                  setState(() {
                                                    // we are not using stream here so it will take data only one time we'll manage that data manually
                                                    isFollowing = true;
                                                    followers++;
                                                  });
                                                },
                                              )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          UserData['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 1.0),
                        child: Text(
                          UserData['bio'],
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('posts')
                        .where('uid', isEqualTo: widget.uid)
                        .get(),
                    builder: ((context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return GridView.builder(
                        shrinkWrap: true,
                        itemCount: (snapshot.data! as dynamic).docs.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 1.5,
                                childAspectRatio: 1),
                        itemBuilder: ((context, index) {
                          DocumentSnapshot snapH =
                              (snapshot.data! as dynamic).docs[index];
                          return Container(
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: ((context) => PostCard(
                                        snap:
                                            snapshot.data!.docs[index].data())),
                                  ),
                                );
                              },
                              child: Image(
                                image: NetworkImage(snapH['photoUrl']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }),
                      );
                    }))
              ],
            ),
          );
  }
}
