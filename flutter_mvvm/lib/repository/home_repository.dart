import 'dart:developer';

import '../data/network/BaseApiServices.dart';
import '../data/network/NetworkApiResponse.dart';
import '../model/movies_model.dart';
import '../resources/app_url.dart';

class HomeRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<List<UsersModel>> fetchMoviesList() async {
    try {
      var response =
          await _apiServices.getGetApiResponse(AppUrl.moviesListEndPoint);
          var res = usersModelFromJson(response);
          log('${response.toString()} from home repository');
          log('${res.first.name} from home repository');
      return usersModelFromJson(response);
    } catch (e) {
      log('$e from home repo');
      rethrow;
    }
  }
}
