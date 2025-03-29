import 'package:riverpod_todo/domain/entities/todo.dart';
import 'package:riverpod_todo/domain/repositories/todo_respository.dart';

class MemoryTodoRepository extends TodoRepository {
  final List<Todo> _todos = [];

  @override
  Future<List<Todo>> getAllTodos() async => [..._todos];

  @override
  Future<void> deleteTodo(String id) async {
    _todos.removeWhere((todo) => todo.id == id);
  }

  @override
  Future<Todo?> getTodoById(String id) async =>
      _todos.firstWhere((todo) => todo.id == id);

  @override
  Future<List<Todo>> getTodoByFilter(TodoFilter filter) async {
    switch (filter) {
      case TodoFilter.all:
        return [..._todos];
      case TodoFilter.active:
        return _todos.where((todo) => !todo.isCompleted).toList();
      case TodoFilter.completed:
        return _todos.where((todo) => todo.isCompleted).toList();
    }
  }

  @override
  Future<void> saveTodo(Todo todo) async {
    final index = _todos.indexWhere((t) => t.id == todo.id);
    if (index >= 0) {
      _todos[index] = todo;
    } else {
      _todos.add(todo);
    }
  }
}
