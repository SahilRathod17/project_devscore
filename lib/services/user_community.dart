import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommunityService {
  final String? uid;
  CommunityService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference communityCollection =
      FirebaseFirestore.instance.collection('communities');

  getUserCommunity() async {
    return userCollection.doc(uid).snapshots();
  }

  // creating community
  Future createCommunity(
      String userName, String id, String CommunityName) async {
    DocumentReference CommunityDocumentReference =
        await communityCollection.add({
      "CommunityName": CommunityName,
      "Icon": "",
      "admin": "${id}_$userName",
      "members": [],
      "CommunityId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });

    // update the members
    await CommunityDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "CommunityId": CommunityDocumentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "community": FieldValue.arrayUnion(
          ["${CommunityDocumentReference.id}_$CommunityName"])
    });
  }

  // getting chats
  getChats(String communityId) async {
    return communityCollection
        .doc(communityId)
        .collection('messages')
        .orderBy('time')
        .snapshots();
  }

  // getting admin
  Future<String> getAdmin(String communityId) async {
    DocumentReference d = communityCollection.doc(communityId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }

  // get members are in community
  getCommunityMembers(communityId) async {
    return communityCollection.doc(communityId).snapshots();
  }

  // search
  searchByName(String communityName) {
    return communityCollection
        .where('CommunityName', isEqualTo: communityName)
        .get();
  }

  // return bool value : in community or not ?
  Future<bool> isUserJoined(
      String CommunityName, String CommunityId, String username) async {
    DocumentReference userDocumentRefrence =
        userCollection.doc(FirebaseAuth.instance.currentUser!.uid);

    DocumentSnapshot documentSnapshot = await userDocumentRefrence.get();

    List<dynamic> community = await documentSnapshot['community'];
    if (community.contains("${CommunityId}_$CommunityName")) {
      return true;
    } else {
      return false;
    }
  }

  // joining the community
  Future toggleCommunity(
      String CommunityId, String username, String CommunityName) async {
    DocumentReference userDocumentReference =
        userCollection.doc(FirebaseAuth.instance.currentUser!.uid);
    DocumentReference CommunityDocumentReference =
        communityCollection.doc(CommunityId);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> Community = await documentSnapshot['community'];

    // if user has
    if (Community.contains("${CommunityId}_$CommunityName")) {
      await userDocumentReference.update({
        "community": FieldValue.arrayRemove(["${CommunityId}_$CommunityName"])
      });

      await CommunityDocumentReference.update({
        'members': FieldValue.arrayRemove(["${uid}_$username"])
      });
    } else {
      await userDocumentReference.update({
        "community": FieldValue.arrayUnion(["${CommunityId}_$CommunityName"])
      });

      await CommunityDocumentReference.update({
        'members': FieldValue.arrayUnion(["${uid}_$username"])
      });
    }
  }

  // leave community
  leavecommunity(
      String CommunityId, String username, String CommunityName) async {
    DocumentReference userDocumentReference =
        userCollection.doc(FirebaseAuth.instance.currentUser!.uid);
    DocumentReference CommunityDocumentReference =
        communityCollection.doc(CommunityId);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> Community = await documentSnapshot['community'];

    if (Community.contains("${CommunityId}_$CommunityName")) {
      await userDocumentReference.update({
        "community": FieldValue.arrayRemove(["${CommunityId}_$CommunityName"])
      });

      await CommunityDocumentReference.update({
        'members': FieldValue.arrayRemove(["${uid}_$username"])
      });
    }
  }

  // send message
  sendMessage(String CommunityId, Map<String, dynamic> ChatMessageData) async {
    communityCollection
        .doc(CommunityId)
        .collection("messages")
        .add(ChatMessageData);
    communityCollection.doc(CommunityId).update({
      "recentMessage": ChatMessageData['message'],
      "recentMessageSender": ChatMessageData['sender'],
      "recentMessageTime": ChatMessageData['time'].toString(),
    });
  }
}
