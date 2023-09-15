import 'package:api_integration_bloc/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class UserRepository {
  String url = 'https://reqres.in/api/users?page=2';
  UsersModel? data = UsersModel();

  Future<UsersModel> getusers() async {
    try {
      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // data = jsonDecode(response.body);
        data = usersModelFromJson(response.body);
        if (kDebugMode) {
          print('FROM HERE');
          // print(data.toString());
        }
      } else {
        if (kDebugMode) {
          print('Error');
        }

        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      if (kDebugMode) {
        print('$e FROM try catch.');
      }
    }
    return data!;
  }
}


