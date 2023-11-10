import 'package:api_integration_dio_bloc/data/modals/posts_modal.dart';
import 'package:api_integration_dio_bloc/data/repositories/api/api.dart';
import 'package:dio/dio.dart';

class PostRepository {
  API api = API();

  Future<List<UserPosts>> fetchPosts() async {
    try {
      Response response = await api.sendRequest.get('/posts');
      List<dynamic> postMaps = response.data;
      return postMaps.map((postMaps) => UserPosts.fromJson(postMaps)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
