// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserService extends ChangeNotifier {
  String baseUrl = 'https://reqres.in/';
  String login_endpoint = 'api/login';
  String signup_endpoint = 'api/register';
  bool isLoading = false;

  Future<void> login(
    String email,
    String password,
  ) async {
    updateLoader(true);
    final response = await http.post(
      Uri.parse(baseUrl + login_endpoint),
      body: {
        'email': email,
        'password': password,
      },
    );
    if (response.statusCode == 200) {
      debugPrint('success login');
      updateLoader(false);
    } else {
      debugPrint('failure login');
      updateLoader(false);
    }
  }

  Future<void> signup(
    String email,
    String password,
  ) async {
    updateLoader(true);
    final response = await http.post(
      Uri.parse(baseUrl + signup_endpoint),
      body: {
        'email': email,
        'password': password,
      },
    );
    if (response.statusCode == 200) {
      debugPrint('success signup');
      updateLoader(false);
    } else {
      debugPrint('failure signup');
      updateLoader(false);
    }
  }

  updateLoader(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
