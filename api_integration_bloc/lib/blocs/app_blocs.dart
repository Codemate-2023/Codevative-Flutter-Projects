import 'package:api_integration_bloc/blocs/app_events.dart';
import 'package:api_integration_bloc/blocs/app_state.dart';
import 'package:api_integration_bloc/repository/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  // ignore: unused_field, prefer_final_fields
  UserRepository _userRepository = UserRepository();
  UserBloc(this._userRepository) : super(UserLoadingState()) {
    on<LoadUserEvent>((event, emit) async {
      emit(UserLoadingState());
      try {
        debugPrint('before users');
        final users = await _userRepository.getusers();
        debugPrint('after users');
        emit(UserLoadedState(users.data!));
      } catch (e) {
        emit(UserErrorState(e.toString()));
      }
    });
  }
}
