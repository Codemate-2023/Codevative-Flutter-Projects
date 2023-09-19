
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:users_app/users_model.dart';

class ApiService {
  Future<List<UsersModel>> getUsers() async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users'),
    );

    if (response.statusCode == 200) {
      log(response.body.toString());
      return usersModelFromJson(response.body);
    } else {
      throw Exception('Failed to load users');
    }
  }

//   Future<UsersModel> fetchAlbum() async {
//   final response = await http
//       .get(Uri.parse('https://jsonplaceholder.typicode.com/albums'));

//   if (response.statusCode == 200) {
//     return UsersModel.fromJson(jsonDecode(response.body));
//   } else {
//     throw Exception('Failed to load album');
//   }
// }
}
