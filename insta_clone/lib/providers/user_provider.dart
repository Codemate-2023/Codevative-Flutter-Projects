import 'package:flutter/material.dart';
import 'package:insta_clone/modals/user_modal.dart';
import 'package:insta_clone/resources/auth.dart';

class UserProvider extends ChangeNotifier {
  Users? _users;
  final Auth auth = Auth();

  Users get getUser => _users!;

  Future<void> refreshUser() async {
    Users user = await auth.getUserDetails();
    print('${user.toJson()} from user provider');
    _users = user;
    notifyListeners();
  }
}
