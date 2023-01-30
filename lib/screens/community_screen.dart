// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_devscore/services/user_community.dart';
import 'package:project_devscore/utils/colors.dart';
import 'package:project_devscore/utils/string_manipulation.dart';
import 'package:project_devscore/widgets/community_card.dart';
import 'package:project_devscore/widgets/snackbar.dart';

class CommunityScreen extends StatefulWidget {
  final String uid;
  final bool showBackOption;
  CommunityScreen({required this.uid, required this.showBackOption});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  var UserData = {};
  // community
  String userName = "";
  String email = "";
  Stream? Community;
  bool _isLoading = false;
  String CommunityName = "";

  @override
  void initState() {
    super.initState();
    gettingData();
  }

  gettingData() async {
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      UserData = userSnap.data()!;
      setState(() {
        userName = UserData['username'];
      });
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    await CommunityService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserCommunity()
        .then((snapshot) {
      setState(() {
        Community = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: blackColor,
        ),
        leading: widget.showBackOption == true
            ? IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded))
            : null,
        centerTitle: true,
        elevation: 0,
        backgroundColor: primaryColor,
        title: const Text(
          'DevsCore',
          style: TextStyle(
            color: blueColor,
            fontFamily: 'pacifico',
            fontSize: 35,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              popUpDialog(context);
            },
            icon: const Icon(
              Icons.add,
              color: blackColor,
              size: 30.0,
            ),
          ),
        ],
      ),
      body: CommunityList(),
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: ((context) {
        return StatefulBuilder(
          builder: ((context, setState) {
            return AlertDialog(
              title: const Text(
                'Build Community',
                style: TextStyle(color: blueColor, fontFamily: 'pacifico'),
                textAlign: TextAlign.left,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isLoading == true
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor,
                          ),
                        )
                      : TextField(
                          style: const TextStyle(
                            color: blackColor,
                          ),
                          onChanged: (val) {
                            setState(() {
                              CommunityName = val;
                            });
                          },
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                                borderRadius: BorderRadius.circular(25)),
                            errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(25)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                                borderRadius: BorderRadius.circular(25)),
                          ),
                        ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (CommunityName != "") {
                      setState(() {
                        _isLoading = true;
                      });
                      CommunityService(
                              uid: FirebaseAuth.instance.currentUser!.uid)
                          .createCommunity(
                              userName,
                              FirebaseAuth.instance.currentUser!.uid,
                              CommunityName)
                          .whenComplete(() => _isLoading = false);
                      Navigator.of(context).pop();
                      showSnackBar(context, 'Success');
                    }
                  },
                  style: ElevatedButton.styleFrom(),
                  child: const Text(
                    'Start',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            );
          }),
        );
      }),
    );
  }

  CommunityList() {
    return StreamBuilder(
      stream: Community,
      builder: ((context, AsyncSnapshot snapshot) {
        //       // checks
        if (snapshot.hasData &&
            snapshot.connectionState != ConnectionState.waiting) {
          if (snapshot.data!['community'] != null) {
            if (snapshot.data['community'].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data['community'].length,
                itemBuilder: ((context, index) {
                  int reverseIndex =
                      snapshot.data['community'].length - index - 1;
                  return CommunityCard(
                      CommunityId:
                          getId(snapshot.data['community'][reverseIndex]),
                      CommunityName:
                          getName(snapshot.data['community'][reverseIndex]),
                      username: snapshot.data['username']);
                }),
              );
            } else {
              return JoinCommunity();
            }
          } else {
            return JoinCommunity();
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
            // child: JoinCommunity(),
          );
        }
      }),
    );
  }

  JoinCommunity() {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                popUpDialog(context);
              },
              child: const Icon(
                Icons.add_circle,
                color: blueColor,
                size: 75,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Join Community on DevsCore!!',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
