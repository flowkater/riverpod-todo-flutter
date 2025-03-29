import 'package:riverpod_todo/domain/entities/todo.dart';

abstract class TodoRepository {
  Future<List<Todo>> getAllTodos();
  Future<Todo?> getTodoById(String id);
  Future<void> saveTodo(Todo todo);
  Future<void> deleteTodo(String id);
  Future<List<Todo>> getTodoByFilter(TodoFilter filter);
}

enum TodoFilter { all, active, completed }
