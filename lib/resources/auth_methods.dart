import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/user.dart' as model;
import 'package:instagram_flutter/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(snap);
  }

  // Signup with email and password
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error occured";

    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          bio.isNotEmpty &&
          file != null) {
        UserCredential authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String photoUrl = await StorageMethods()
            .uploadImageToStroage('profilepics', file, false);

        model.User user = model.User(
          email: email,
          username: username,
          uid: authResult.user!.uid,
          bio: bio,
          photoUrl: photoUrl,
          followers: [],
          following: [],
        );

        if (authResult.user!.uid != null) {
          await _firestore.collection('users').doc(authResult.user?.uid).set(
                user.toJson(),
              );

          res = 'success';
        }
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = 'Email is badly formatted.';
      } else if (err.code == 'weak-password') {
        res = 'Password is not strong enough.';
      } else if (err.code == 'email-already-in-use') {
        res = 'Email is already in use.';
      } else if (err.code == 'user-not-found') {
        res = 'User not found.';
      } else if (err.code == 'user-disabled') {
        res = 'User is disabled.';
      } else if (err.code == 'wrong-password') {
        res = 'Wrong password.';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occured";

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        UserCredential authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);

        if (authResult.user!.uid != null) {
          res = 'success';
        }
      } else {
        res = 'Please enter email and password.';
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = 'Email is badly formatted.';
      } else if (err.code == 'user-not-found') {
        res = 'User not found.';
      } else if (err.code == 'user-disabled') {
        res = 'User is disabled.';
      } else if (err.code == 'wrong-password') {
        res = 'Wrong password.';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> logoutUser() async {
    return await _auth.signOut();
  }
}
