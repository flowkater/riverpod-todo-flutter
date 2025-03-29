import 'package:riverpod_todo/domain/entities/todo.dart';
import 'package:riverpod_todo/domain/repositories/todo_respository.dart';

Future<List<Todo>> getAllTodosUsecase(TodoRepository todoRepository) async {
  return await todoRepository.getAllTodos();
}

Future<void> addTodoUsecase(TodoRepository todoRepository, String title) async {
  final todo = Todo(title: title);
  await todoRepository.saveTodo(todo);
}

Future<void> deleteTodoUsecase(TodoRepository todoRepository, String id) async {
  await todoRepository.deleteTodo(id);
}

Future<void> toggleTodoUsecase(TodoRepository todoRepository, String id) async {
  final todo = await todoRepository.getTodoById(id);
  if (todo != null) {
    final updatedTodo = todo.copyWith(isCompleted: !todo.isCompleted);
    await todoRepository.saveTodo(updatedTodo);
  }
}

Future<List<Todo>> getTodosByFilterUsecase(
  TodoRepository todoRepository,
  TodoFilter filter,
) async {
  return await todoRepository.getTodoByFilter(filter);
}

Future<void> updateTodoTitleUsecase(
  TodoRepository todoRepository,
  String id,
  String title,
) async {
  final todo = await todoRepository.getTodoById(id);
  if (todo != null) {
    final updatedTodo = todo.copyWith(title: title);
    await todoRepository.saveTodo(updatedTodo);
  }
}
