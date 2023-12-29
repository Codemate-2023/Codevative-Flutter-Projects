// ignore_for_file: avoid_print

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc_app/home/bloc/home_state.dart';

import '../../services/authentication.dart';
import '../../services/todo.dart';
import 'home_event.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AuthenticationService _auth;
  final TodoService _todo;

  HomeBloc(this._auth, this._todo) : super(const RegisteringServiceState()) {
    on<LoginEvent>(
      (event, emit) async {
        final user = await _auth.authenticateUser(
          event.username,
          event.password,
        );
        if (user != null) {
          emit(SuccessfulLoginState(user));
          emit(const HomeInitial());
        }
      },
    );

    on<RegisterAccountEvent>(
      (event, emit) async {
        final result = await _auth.createUser(event.username, event.password);
        switch (result) {
          case UserCreateResult.success:
            emit(SuccessfulLoginState(event.username));
            break;
          case UserCreateResult.failure:
            emit(const HomeInitial(error: 'An error occurred!'));
            break;
          case UserCreateResult.exists:
            emit(const HomeInitial(error: 'User already exists!'));
            break;
        }
      },
    );

    on<RegisteringServiceEvent>((event, state) async {
      await _auth.init();
      await _todo.init();

      emit(const HomeInitial());
    });
  }
}
