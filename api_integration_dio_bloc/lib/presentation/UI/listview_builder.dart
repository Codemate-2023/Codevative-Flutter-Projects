import 'package:flutter/material.dart';

import '../../data/modals/posts_modal.dart';

class UsersList extends StatefulWidget {
  final List<UserPosts> post;
  const UsersList({
    super.key,
    required this.post,
  });

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.post.length,
      itemBuilder: (context, index) {
        UserPosts post = widget.post[index];
        return ListTile(
          title: Text(post.title!.toUpperCase().toString()),
          subtitle: Text(post.body.toString()),
        );
      },
    );
  }
}
