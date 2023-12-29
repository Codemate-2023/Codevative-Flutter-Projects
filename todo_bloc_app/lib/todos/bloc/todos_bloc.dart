import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc_app/todos/bloc/todos.state.dart';
import 'package:todo_bloc_app/todos/bloc/todos_event.dart';

import '../../services/todo.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  final TodoService _todoService;

  TodosBloc(this._todoService) : super(TodosInitial()) {
    on<LoadTodosEvent>(
      (event, emit) {
        final todos = _todoService.getTasks(event.username);
        emit(TodosLoadedState(todos, event.username));
      },
    );

    on<AddTodoEvent>(
      (event, emit) async {
        final currentState = state as TodosLoadedState;
        _todoService.addTask(
          event.todoText,
          currentState.username,
        );
        add(
          LoadTodosEvent(currentState.username),
        );
      },
    );

    on<ToggleTodoEvent>(
      (event, emit) async {
        final currentState = state as TodosLoadedState;
        await _todoService.updateTask(event.todoTask, currentState.username);
        add(
          LoadTodosEvent(currentState.username),
        );
      },
    );
  }
}
