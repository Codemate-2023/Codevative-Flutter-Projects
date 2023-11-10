// To parse this JSON data, do
//
//     final userPosts = userPostsFromJson(jsonString);

import 'dart:convert';

List<UserPosts> userPostsFromJson(String str) =>
    List<UserPosts>.from(json.decode(str).map((x) => UserPosts.fromJson(x)));

String userPostsToJson(List<UserPosts> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserPosts {
  int? userId;
  int? id;
  String? title;
  String? body;

  UserPosts({
    this.userId,
    this.id,
    this.title,
    this.body,
  });

  factory UserPosts.fromJson(Map<String, dynamic> json) => UserPosts(
        userId: json["userId"],
        id: json["id"],
        title: json["title"],
        body: json["body"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "id": id,
        "title": title,
        "body": body,
      };
}
