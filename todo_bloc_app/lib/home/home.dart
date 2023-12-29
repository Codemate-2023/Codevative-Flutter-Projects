import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc_app/home/bloc/home_bloc.dart';
import 'package:todo_bloc_app/home/bloc/home_event.dart';
import 'package:todo_bloc_app/services/authentication.dart';
import 'package:todo_bloc_app/todos/todo.dart';
import '../services/todo.dart';
import 'bloc/home_state.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page ToDo App'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(
            RepositoryProvider.of<AuthenticationService>(context),
            RepositoryProvider.of<TodoService>(context),
          )..add(
              const RegisteringServiceEvent(),
            ),
          child: BlocConsumer<HomeBloc, HomeState>(
            listener: (context, state) {
              if (state is SuccessfulLoginState) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TodoPage(username: state.username!),
                  ),
                );
              }

              if (state is HomeInitial) {
                if (state.error != null) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: Text(state.error!),
                      );
                    },
                  );
                }
              }
            },
            builder: (context, state) {
              if (state is HomeInitial) {
                return Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Username',
                      ),
                      controller: usernameController,
                    ),
                    TextField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                      controller: passwordController,
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () =>
                              BlocProvider.of<HomeBloc>(context).add(
                            LoginEvent(
                              usernameController.text,
                              passwordController.text,
                            ),
                          ),
                          child: const Center(
                            child: Text('Log In'),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        ElevatedButton(
                          onPressed: () =>
                              BlocProvider.of<HomeBloc>(context).add(
                            RegisterAccountEvent(
                              usernameController.text,
                              passwordController.text,
                            ),
                          ),
                          child: const Center(
                            child: Text('Register'),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
