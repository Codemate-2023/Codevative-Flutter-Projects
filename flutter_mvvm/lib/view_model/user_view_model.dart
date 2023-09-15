import 'dart:developer';

import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user_model.dart';

class UserViewModel with ChangeNotifier {
  Future<bool> saveUser(UserModel user) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', user.token!);
      log('${prefs.getString('token').toString()} from shared preferences.');
      notifyListeners();
    } catch (e) {
      if(kDebugMode){
        print('${e.toString()} from save user.');
      }
    }

    return true;
  }

  Future<UserModel> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    return UserModel(token: token.toString());
  }

  Future<bool> removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }
}
