import 'package:api_integration_bloc/models/user_model.dart';
import 'package:flutter/material.dart';

import 'package:equatable/equatable.dart';

@immutable
abstract class UserState extends Equatable {}

class UserLoadingState extends UserState {
  @override
  List<Object?> get props => [];
}

class UserLoadedState extends UserState {
  UserLoadedState(this.users);

  final List<Datum> users;
  @override
  List<Object?> get props => [users];
}

class UserErrorState extends UserState {
  UserErrorState(this.error);

  final String error;
  @override
  List<Object?> get props => [error];
}