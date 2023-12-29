import 'dart:ffi';

import 'package:hive/hive.dart';

import '../model/user.dart';

class AuthenticationService {
  late Box<User> _users;

  Future<void> init() async {
    Hive.registerAdapter(UserAdapter());
    _users = await Hive.openBox<User>('usersBox');

    // await _users.add(User('yasir', 'password'));
    // await _users.add(User('danish', 'password'));
  }

  Future<String?> authenticateUser(
    final String username,
    final String password,
  ) async {
    final success = _users.values.any(
      (element) => element.username == username && element.password == password,
    );

    if (success) {
      return username;
    } else {
      return null;
    }
  }

  Future<UserCreateResult> createUser(
    final String username,
    final String password,
  ) async {
    final alreadyExists = _users.values.any(
      (element) => element.username.toLowerCase() == username.toLowerCase(),
    );

    if (alreadyExists) {
      return UserCreateResult.exists;
    }

    try {
      _users.add(User(username, password));
      return UserCreateResult.success;
    } on Exception catch (e) {
      return UserCreateResult.failure;
    }
  }
}

enum UserCreateResult {
  success,
  failure,
  exists,
}
