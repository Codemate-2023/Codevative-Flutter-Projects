import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_clone/modals/posts.dart';
import 'package:insta_clone/resources/storage.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var uuid = const Uuid();

  Future<String> uploadPost(
    String description,
    Uint8List file,
    String image,
    String username,
    String uid,
  ) async {
    String res = "some error occurred.";
    try {
      String photoUrl = await StorageMethod().uploadImageToStorage(
        'posts',
        file,
        true,
      );

      String postId = uuid.v4();
      Posts posts = Posts(
        uid: uid,
        username: username,
        description: description,
        profileImage: image,
        postId: postId,
        datePublished: DateTime.now().toString(),
        postUrl: photoUrl,
      );

      _firestore.collection('posts').doc(postId).set(
            posts.toJson(),
          );
      res = "success";
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<void> likePost(
    String postId,
    String uid,
    List likes,
  ) async {
    try {
      if (likes.isNotEmpty && likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update(
          {
            'likes': FieldValue.arrayRemove([uid])
          },
        );
      } else {
        await _firestore.collection('posts').doc(postId).update(
          {
            'likes': FieldValue.arrayUnion([uid])
          },
        );
      }
    } catch (e) {
      print('${e.toString()} while posting likes.');
    }
  }

  Future<void> postComment(
    String postId,
    String text,
    String uid,
    String name,
    String profilePic,
  ) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set(
          {
            'profilePic': profilePic,
            'name': name,
            'uid': uid,
            'text': text,
            'commentId': commentId,
            'datePublished': DateTime.now(),
          },
        );
      } else {
        print('No comments');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }
}
