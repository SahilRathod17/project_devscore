import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_devscore/screens/community_screen.dart';
import 'package:project_devscore/services/user_community.dart';
import 'package:project_devscore/utils/colors.dart';
import 'package:project_devscore/utils/string_manipulation.dart';
import 'package:project_devscore/widgets/log_out_alert.dart';

class CommunityInfo extends StatefulWidget {
  final String CommunityId;
  final String CommunityName;
  final String adminName;
  final String username;

  CommunityInfo({
    required this.CommunityId,
    required this.CommunityName,
    required this.adminName,
    required this.username,
  });

  @override
  State<CommunityInfo> createState() => _CommunityInfoState();
}

class _CommunityInfoState extends State<CommunityInfo> {
  Stream? members;
  @override
  void initState() {
    super.initState();
    getMembers();
  }

  getMembers() async {
    CommunityService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getCommunityMembers(widget.CommunityId)
        .then((val) {
      setState(() {
        members = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Community Info',
          style: TextStyle(
            color: blackColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: blackColor),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
        actions: [
          TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: ((context) {
                    return LogOutAlert(
                        title: 'Leave Community',
                        content: 'Are your sure you want to leave ?',
                        onPressed: () {
                          CommunityService().leavecommunity(widget.CommunityId,
                              widget.username, widget.CommunityName);
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        });
                  }),
                );
              },
              child: const Text(
                'Leave',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Theme.of(context).primaryColor.withOpacity(0.2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(
                      widget.CommunityName.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Community : ${widget.CommunityName}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        "Admin : ${getName(widget.adminName)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            membersList(),
          ],
        ),
      ),
    );
  }

  membersList() {
    return StreamBuilder(
        stream: members,
        builder: ((context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data['members'] != null) {
              if (snapshot.data['members'].length != 0) {
                return ListView.builder(
                  itemCount: snapshot.data['members'].length,
                  shrinkWrap: true,
                  itemBuilder: ((context, index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 10,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            getName(snapshot.data['members'][index])
                                .substring(0, 1)
                                .toUpperCase(),
                            style: const TextStyle(
                              color: primaryColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          getName(snapshot.data['members'][index]),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(getId(snapshot.data['members'][index])),
                      ),
                    );
                  }),
                );
              } else {
                return const Center(
                  child: Text(
                    'No Members',
                    style: TextStyle(
                      color: blackColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
            } else {
              return const Center(
                child: Text(
                  'No Members',
                  style: TextStyle(
                    color: blackColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: blueColor,
              ),
            );
          }
        }));
  }
}
