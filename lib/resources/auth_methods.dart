import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<String> signUpUser({
    required String email,
    required String password,
    required String userName,
    required String bio,
    // required Uint8List file
  }) async {
    String res = "some error occured";

    try {
      if (email.isNotEmpty ||
              password.isNotEmpty ||
              userName.isNotEmpty ||
              bio.isNotEmpty
          //||
          // file != null
          ) {
        // regisister user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        print(cred.user!.uid);
        _firebaseFirestore.collection("users").doc(cred.user!.uid).set({
          'userName': userName,
          "password": password,
          'bio': bio,
          'followers': [],
          'following': []
        });
        res = "success";

        // add user to the database
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> loginMethods(
      {required String email, required String password}) async {
    String res = "some error occured";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
