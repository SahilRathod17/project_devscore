import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:project_devscore/model/user_posts.dart';
import 'package:project_devscore/services/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // upload post
  Future uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImage,
  ) async {
    String res = 'Some error occurred';
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);

      // uuid provides unique ids
      String postID = const Uuid().v1();

      Post post = Post(
        profImage: profImage,
        uid: uid,
        photoUrl: photoUrl,
        username: username,
        datePublished: DateTime.now(),
        description: description,
        postID: postID,
        likes: [],
      );

      _firestore.collection('posts').doc(postID).set(
            post.toJson(),
          );
      res = 'done';
    } catch (e) {
      res = e.toString();
      print(e);
    }
    return res;
  }

  Future<void> likePost(String postID, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        // means user has already liked the post
        await _firestore.collection('posts').doc(postID).update({
          // remove like
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postID).update({
          // add like
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> postComment(String postID, String uid, String text, String name,
      String profilePic) async {
    try {
      if (text.isNotEmpty) {
        String commentID = const Uuid().v1();

        await _firestore
            .collection('posts')
            .doc(postID)
            .collection('comments')
            .doc(commentID)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'commentID': commentID,
          'datePublished': DateTime.now(),
          'text': text,
        });
      } else {
        print('empty comment');

        /// do nothing
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // delete post

  Future<void> deletePost(String postID) async {
    try {
      await _firestore.collection('posts').doc(postID).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> FollowUsers(String uid, String followID) async {
    try {
      // getting current users following list
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      // storing that list in our local List
      List following = (snap.data()! as dynamic)['following'];
      // now if some users id is available in that list means user follows that user
      // so remove the user form there , if current users already follows that user
      if (following.contains(followID)) {
        // think as uid is you and followID is second person
        // from that person's followers list you will be removed
        await _firestore.collection('users').doc(followID).update({
          'followers': FieldValue.arrayRemove([uid]),
        });

        // remove that person from your following list
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followID]),
        });
      } else {
        // your id added to that person's followers list
        await _firestore.collection('users').doc(followID).update({
          'followers': FieldValue.arrayUnion([uid]),
        });
        // that person's id added to your following list
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followID]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }


}
