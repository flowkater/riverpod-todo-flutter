import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo/application/usecases/todo_usecase.dart';
import 'package:riverpod_todo/domain/entities/todo.dart';
import 'package:riverpod_todo/domain/repositories/todo_respository.dart';
import 'package:riverpod_todo/infrastructure/repositories/memory_todo_repository.dart';

final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  return MemoryTodoRepository();
});

final todoFilterProvider = StateProvider<TodoFilter>((ref) => TodoFilter.all);

final todosProvider = FutureProvider<List<Todo>>((ref) async {
  final todoRepository = ref.watch(todoRepositoryProvider);
  final filter = ref.watch(todoFilterProvider);
  return await getTodosByFilterUsecase(todoRepository, filter);
});

final todoActionsProvider = Provider<TodoActions>((ref) {
  final repository = ref.watch(todoRepositoryProvider);
  return TodoActions(repository: repository, ref: ref);
});

class TodoActions {
  final TodoRepository repository;
  final Ref ref;

  TodoActions({required this.repository, required this.ref});

  Future<void> addTodo(String title) async {
    await addTodoUsecase(repository, title);
    ref.invalidate(todosProvider);
  }

  Future<void> deleteTodo(String id) async {
    await deleteTodoUsecase(repository, id);
    ref.invalidate(todosProvider);
  }

  Future<void> toggleTodo(String id) async {
    await toggleTodoUsecase(repository, id);
    ref.invalidate(todosProvider);
  }

  Future<void> updateTodoTitle(String id, String title) async {
    await updateTodoTitleUsecase(repository, id, title);
    ref.invalidate(todosProvider);
  }
}
