// To parse this JSON data, do
//
//     final Posts = PostsFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Posts {
  String? description;
  String? uid;
  String? username;
  String? postId;
  String? datePublished;
  String? postUrl;
  String? profileImage;
  List? likes;

  Posts({
    this.username,
    this.uid,
    this.datePublished,
    this.description,
    this.postId,
    this.postUrl,
    this.profileImage,
    this.likes,
  });

  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "username": username,
        "postId": postId,
        "datePublished": datePublished,
        "profileImage": profileImage,
        "likes": likes,
        "postUrl": postUrl,
      };

  static Posts fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return Posts(
      uid: snap['uid'],
      username: snap['username'],
      description: snap['description'],
      datePublished: snap['datePublished'],
      likes: snap['likes'] ?? [],
      postId: snap['postId'],
      postUrl: snap['postUrl'],
      profileImage: snap['profileImage'],
    );
  }
}
