import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mvvm/model/user_model.dart';
import 'package:flutter_mvvm/repository/auth_repository.dart';
import 'package:flutter_mvvm/utils/routes/routes_name.dart';
import 'package:flutter_mvvm/utils/routes/utils.dart';
import 'package:flutter_mvvm/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class AuthViewModel with ChangeNotifier {
  final _myRepo = AuthRepository();
  bool _loading = false;
  bool _signuploading = false;
  bool get signuploading => _signuploading;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  setSignupLoading(bool value) {
    _signuploading = value;
    notifyListeners();
  }

  Future<void> loginApi(dynamic data, BuildContext context) async {
    setLoading(true);
    log('$data from login api');
    _myRepo.loginApi(data).then(
      (value) {
        setLoading(false);
        log('$value after loading');
        final prefs = Provider.of<UserViewModel>(context, listen: false);
        prefs.saveUser(
          UserModel(
            token: value,
          ),
        );
        if (kDebugMode) {
          Utils.flushBarMessage('Login successful!', context);
          Navigator.pushNamed(context, RoutesName.home);
          print('$value from there');
        }
      },
    ).onError(
      (error, stackTrace) {
        if (kDebugMode) {
          setLoading(false);
          Utils.flushBarMessage(error.toString(), context);
          print('$error \n$stackTrace from here');
        }
      },
    );
  }

  Future<void> signupApi(dynamic data, BuildContext context) async {
    setSignupLoading(true);
    _myRepo.signupApi(data).then(
      (value) {
        setSignupLoading(false);
        if (kDebugMode) {
          Utils.flushBarMessage('Sign Up successful!', context);
          Navigator.pushNamed(context, RoutesName.home);
          print('$value from there');
        }
      },
    ).onError(
      (error, stackTrace) {
        if (kDebugMode) {
          setSignupLoading(false);
          Utils.flushBarMessage(error.toString(), context);
          print('$error from here');
        }
      },
    );
  }
}
