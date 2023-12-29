// ignore_for_file: dead_code

import 'package:download_pdf_flutter/route_constants.dart';
import 'package:download_pdf_flutter/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'home_screen.dart';
import 'login_screen.dart';

class AppRouter {
  GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        name: RouteConstants.home,
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: MyHomePage(),
          );
        },
      ),
      GoRoute(
        path: '/signup',
        name: RouteConstants.signup,
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: SignUpScreen(),
          );
        },
      ),
      GoRoute(
        path: '/login',
        name: RouteConstants.login,
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: LoginScreen(),
          );
        },
      ),
    ],
    redirect: (
      context,
      state,
    ) {
      bool isAuthenticated = false;
      if (!isAuthenticated && state.matchedLocation == RouteConstants.home) {
        return state.namedLocation(RouteConstants.login);
      }
      return null;
    },
  );
}
