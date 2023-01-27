import 'package:cloud_firestore/cloud_firestore.dart';

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
  Future getAdmin(String communityId) async {
    DocumentReference d = communityCollection.doc(communityId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }

  // get members are in community
  getCommunityMembers(communityId) async {
    return communityCollection.doc(communityId).snapshots();
  }
}
