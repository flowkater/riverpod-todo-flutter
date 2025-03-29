import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo/domain/repositories/todo_respository.dart';
import 'package:riverpod_todo/presentation/providers/todo_provider.dart';
import 'package:riverpod_todo/ui/components/todo_item.dart';

class TodoScreen extends ConsumerWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 비동기 데이터를 구독
    final todosAsync = ref.watch(todosProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('DDD 패턴 Todo 앱'),
        actions: [
          // 필터 드롭다운
          DropdownButton<TodoFilter>(
            value: ref.watch(todoFilterProvider),
            onChanged: (value) {
              if (value != null) {
                ref.read(todoFilterProvider.notifier).state = value;
              }
            },
            items:
                TodoFilter.values.map((filter) {
                  return DropdownMenuItem(
                    value: filter,
                    child: Text(filter.name),
                  );
                }).toList(),
          ),
        ],
      ),
      body: todosAsync.when(
        data: (todos) {
          if (todos.isEmpty) {
            return const Center(child: Text('할 일이 없습니다. 새로운 할 일을 추가해보세요!'));
          }
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return TodoItem(todo: todo);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('오류가 발생했습니다: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTodoDialog(context, ref);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context, WidgetRef ref) {
    final textController = TextEditingController();
    final todoActions = ref.read(todoActionsProvider);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('새 할 일 추가'),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(labelText: '할 일'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                final title = textController.text.trim();
                if (title.isNotEmpty) {
                  todoActions.addTodo(title);
                  Navigator.pop(context);
                }
              },
              child: const Text('추가'),
            ),
          ],
        );
      },
    );
  }
}
