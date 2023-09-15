import 'package:api_integration_bloc/blocs/app_blocs.dart';
import 'package:api_integration_bloc/blocs/app_events.dart';
import 'package:api_integration_bloc/blocs/app_state.dart';
import 'package:api_integration_bloc/models/user_model.dart';
import 'package:api_integration_bloc/repository/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RepositoryProvider(
        create: (_) => UserRepository(),
        child: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc(
        RepositoryProvider.of(context),
      )..add(
          LoadUserEvent(),
        ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bloc App'),
          centerTitle: true,
        ),
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is UserLoadedState) {
              return ListView.builder(
                itemCount: state.users.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Card(
                      color: Colors.blue,
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        title: Text(
                          state.users[index].firstName!,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          state.users[index].email!,
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: CircleAvatar(
                          backgroundImage:
                              NetworkImage(state.users[index].avatar!),
                          radius: 30.0,
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            if (state is UserErrorState) {
              return const Center(
                child: Text('Error'),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
