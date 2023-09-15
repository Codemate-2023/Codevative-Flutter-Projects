// ignore_for_file: unnecessary_null_comparison

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insta_clone/resources/storage.dart';

import '../modals/user_modal.dart' as model;

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.Users> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.Users.fromSnap(snap);
  }

  Future<String> signup({
    required String username,
    required String email,
    required String password,
    required String bio,
    required Uint8List image,
  }) async {
    String response = "Some error occurred.";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          image != null) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        debugPrint(cred.user!.uid);
        String photoUrl = await StorageMethod().uploadImageToStorage(
          'profilePics',
          image,
          false,
        );

        debugPrint('$photoUrl $image from here in sign up 234');

        model.Users user = model.Users(
          username: username,
          uid: cred.user!.uid,
          email: email,
          bio: bio,
          followers: [],
          following: [],
          photoUrl: photoUrl,
        );
        debugPrint('${user.photoUrl} from here in sign up');
        await _firestore.collection('users').doc(cred.user!.uid).set(
              user.toJson(),
            );
        response = 'success';
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'invalid-email') {
        debugPrint('Email is badly formatted.');
      } else if (error.code == 'weak-password') {
        debugPrint('password should be at least 6 characters.');
      }
      response = error.toString();
      debugPrint('$response from here');
    }

    return response;
  }

  Future<String> login(String email, String password) async {
    String response = "some error message";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        response = 'success login';
      } else {
        response = 'please enter all the fields.';
      }
    } catch (e) {
      debugPrint('$e login');
    }
    return response;
  }

  logout() {
    FirebaseAuth.instance.signOut();
  }
}
