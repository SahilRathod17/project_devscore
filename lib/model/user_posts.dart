import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final String postID;
  final DateTime datePublished;
  final String photoUrl;
  final String profImage;
  final likes;

  const Post({
    required this.profImage,
    required this.uid,
    required this.photoUrl,
    required this.username,
    required this.datePublished,
    required this.description,
    required this.postID,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "profImage": profImage,
        "photoUrl": photoUrl,
        "description": description,
        "datePublished": datePublished,
        "postID": postID,
        "likes": likes,
      };

  // doc. snapshot to userdata
  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
      username: snapshot['username'],
      uid: snapshot['uid'],
      photoUrl: snapshot['photoUrl'],
      datePublished: snapshot['datePublished'],
      postID: snapshot['postID'],
      description: snapshot['description'],
      profImage: snapshot['profImage'],
      likes: snapshot['likes'],
    );
  }
}
