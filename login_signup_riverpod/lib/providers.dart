import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_signup_riverpod/service.dart';

final userServiceProvider = ChangeNotifierProvider<UserService>((ref) {
  return UserService();
});
