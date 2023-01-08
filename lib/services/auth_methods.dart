import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:project_devscore/services/storage_methods.dart';
import 'package:project_devscore/model/user_model.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserData() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  // sign up user

  Future<String> SignupUser(
      {required String email,
      required String password,
      required String username,
      required String bio,
      // to read image as bytes
      required Uint8List file}) async {
    String result = "Some error occurred";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String ProfilePicURL = await StorageMethods()
            .uploadImageToStorage('ProfilePicture', file, false);

        // adding user to database

        model.User user = model.User(
          username: username,
          uid: cred.user!.uid,
          email: email,
          bio: bio,
          photoUrl: ProfilePicURL,
          followers: [],
          following: [],
        );

        await _firestore.collection('users').doc(cred.user!.uid).set(
              user.toJson(),
            );

        result = 'success';
      } else {
        result = 'Please enter valid values';
      }
    } on FirebaseAuthException catch (err) {
      result = err.message!;
    }
    return result;
  }

  Future<String> LoginUser(
      {required String email, required String password}) async {
    String result = 'Some error occurred';

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        result = 'success';
      } else {
        result = 'Please enter valid values';
      }
    } on FirebaseAuthException catch (err) {
      result = err.message!;
    }
    return result;
  }
  
}
