import 'package:flutter/material.dart';
import 'package:project_devscore/screens/chat_screen.dart';
import 'package:project_devscore/utils/colors.dart';

class CommunityCard extends StatefulWidget {
  final String username;
  final String CommunityId;
  final String CommunityName;
  CommunityCard(
      {required this.CommunityId,
      required this.CommunityName,
      required this.username});

  @override
  State<CommunityCard> createState() => _CommunityCardState();
}

class _CommunityCardState extends State<CommunityCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
          return ChatPage(
              communityId: widget.CommunityId,
              communityName: widget.CommunityName,
              username: widget.username);
        })));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 10,
        ),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: blueColor,
            child: Text(
              widget.CommunityName.substring(0, 1).toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: primaryColor, fontWeight: FontWeight.bold),
            ),
          ),
          title: Text(
            widget.CommunityName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            'Join the conversation as ${widget.username}',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13.0,
            ),
          ),
        ),
      ),
    );
  }
}
