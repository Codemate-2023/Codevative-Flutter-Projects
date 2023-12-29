import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc_app/todos/bloc/todos.state.dart';
import 'package:todo_bloc_app/todos/bloc/todos_bloc.dart';
import 'package:todo_bloc_app/todos/bloc/todos_event.dart';

import '../services/todo.dart';

class TodoPage extends StatelessWidget {
  final String username;

  const TodoPage({
    super.key,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo App'),
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (context) => TodosBloc(
          RepositoryProvider.of<TodoService>(context),
        )..add(
            LoadTodosEvent(username),
          ),
        child: BlocBuilder<TodosBloc, TodosState>(
          builder: (context, state) {
            if (state is TodosLoadedState) {
              return ListView(
                children: [
                  ...state.tasks.map(
                    (e) => ListTile(
                      title: Text(e.task),
                      trailing: Checkbox(
                        value: e.completed,
                        onChanged: (val) {
                          BlocProvider.of<TodosBloc>(context).add(
                            ToggleTodoEvent(e.task),
                          );
                        },
                      ),
                    ),
                  ),
                  ListTile(
                    title: const Text('create new task'),
                    trailing: const Icon(Icons.create),
                    onTap: () async {
                      final result = await showDialog(
                        context: context,
                        builder: (context) => const Dialog(
                          child: CreateNewTask(),
                        ),
                      );

                      if (result != null) {
                        BlocProvider.of<TodosBloc>(context).add(
                          AddTodoEvent(result),
                        );
                      }
                    },
                  ),
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}

class CreateNewTask extends StatefulWidget {
  const CreateNewTask({super.key});

  @override
  State<CreateNewTask> createState() => _CreateNewTaskState();
}

class _CreateNewTaskState extends State<CreateNewTask> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('What task do you want to create?'),
          TextField(
            controller: controller,
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(controller.text);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
