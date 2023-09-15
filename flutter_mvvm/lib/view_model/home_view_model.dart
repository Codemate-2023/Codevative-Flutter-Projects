import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../model/movies_model.dart';
import '../repository/home_repository.dart';

class HomeViewViewModel with ChangeNotifier {
  final _myRepo = HomeRepository();

  List<UsersModel>? moviesList;
  // ApiResponse<UsersModel> moviesList = ApiResponse.loading();

  setMoviesList(List<UsersModel> response) {
    try {
      moviesList = response;
      log("message ==> $moviesList");
      notifyListeners();
    } catch (e) {
      if(kDebugMode) {
        print('$e from set movies list');
      }
    }
  }

  Future<void> fetchMoviesListApi() async {
    // setMoviesList(ApiResponse.loading());

    // try {
    //   final res = await _myRepo.fetchMoviesList();
    //   setMoviesList(ApiResponse.completed(res));
    //   log('$res from home view model');
    // } catch (e) {
    //   log('$e from home view model');
    // }
    _myRepo.fetchMoviesList().then(
      (value) {
        log('$value from fetch movies list');
        // setMoviesList(ApiResponse.completed(value));
        setMoviesList(value);
      },
    ).onError(
      (error, stackTrace) {
        log('${error.toString()} home view model');
        // setMoviesList(ApiResponse.error());
      },
    );
  }
}
