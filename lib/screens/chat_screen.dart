import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_devscore/screens/community_info.dart';
import 'package:project_devscore/services/user_community.dart';
import 'package:project_devscore/utils/colors.dart';
import 'package:project_devscore/widgets/message.dart';

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
  TextEditingController messageController = TextEditingController();
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
                    username: widget.username,
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
      body: Stack(children: [
        ChatMessages(),
        Container(
          alignment: Alignment.bottomCenter,
          width: MediaQuery.of(context).size.width,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              color: Colors.grey[200],
              child: Row(
                children: [
                  Expanded(
                      child: TextFormField(
                    controller: messageController,
                    style: const TextStyle(color: blackColor),
                    decoration: const InputDecoration(
                      hintText: "Send a message . . .",
                      hintStyle: TextStyle(
                        color: blackColor,
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                    ),
                  )),
                  const SizedBox(
                    width: 12,
                  ),
                  GestureDetector(
                    onTap: () {
                      sendMessage();
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        // color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.send,
                          color: blackColor,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  ChatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                      message: snapshot.data!.docs[index]['message'],
                      sender: snapshot.data!.docs[index]['sender'],
                      sentByMe: widget.username ==
                          snapshot.data!.docs[index]['sender']);
                },
              )
            : Container();
      },
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": widget.username,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      CommunityService().sendMessage(widget.communityId, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }
}
