import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_devscore/screens/community_info.dart';
import 'package:project_devscore/services/user_community.dart';
import 'package:project_devscore/utils/colors.dart';

class ChatPage extends StatefulWidget {
  final String communityId;
  final String communityName;
  final String username;

  ChatPage({
    required this.communityId,
    required this.communityName,
    required this.username,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;
  String admin = "";

  @override
  void initState() {
    super.initState();
    getAdmin();
  }

  getAdmin() async {
    CommunityService().getChats(widget.communityId).then((val) {
      setState(() {
        chats = val;
      });
    });
    CommunityService().getAdmin(widget.communityId).then((value) {
      setState(() {
        admin = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.communityName,
          style: const TextStyle(
            color: blackColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: ((context) {
                  return CommunityInfo(
                    CommunityId: widget.communityId,
                    CommunityName: widget.communityName,
                    adminName: admin,
                  );
                })));
              },
              icon: const Icon(
                Icons.info,
              ))
        ],
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: blackColor),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
      ),
    );
  }
}
