import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo/domain/entities/todo.dart';
import 'package:riverpod_todo/presentation/providers/todo_provider.dart';

class TodoItem extends ConsumerWidget {
  final Todo todo;
  const TodoItem({super.key, required this.todo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoActions = ref.watch(todoActionsProvider);

    return ListTile(
      leading: Checkbox(
        value: todo.isCompleted,
        onChanged: (_) => todoActions.toggleTodo(todo.id),
      ),
      title: Text(
        todo.title,
        style: TextStyle(
          decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text(
        '생성일: ${todo.createdAt.toString().substring(0, 16)}',
        style: TextStyle(fontSize: 12),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _showEditTodoDialog(context, ref);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              todoActions.deleteTodo(todo.id);
            },
          ),
        ],
      ),
    );
  }

  void _showEditTodoDialog(BuildContext context, WidgetRef ref) {
    final textController = TextEditingController(text: todo.title);
    final todoActions = ref.read(todoActionsProvider);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('할 일 수정'),
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
                  todoActions.updateTodoTitle(todo.id, title);
                  Navigator.pop(context);
                }
              },
              child: const Text('수정'),
            ),
          ],
        );
      },
    );
  }
}
