import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/models/task.dart';
import 'package:myapp/viewmodels/auth_viewmodels.dart';
import 'package:myapp/viewmodels/task_viewmodels.dart';

class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authVMProvider);
    final taskState = ref.watch(taskVMProvider);

    String greeting = 'Your Tasks';
    if (authState is Success) {
      greeting = 'Hello, ${authState.user.firstName}';
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 1,
        title: Text(greeting, style: theme.textTheme.headlineSmall),
        actions: [
          if (authState is Success)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: CircleAvatar(
                backgroundImage: NetworkImage(authState.user.image),
              ),
            ),
        ],
      ),
      body: taskState.when(
        idle: () => const SizedBox.shrink(),
        loading: () => Center(
          child: CircularProgressIndicator(color: theme.colorScheme.primary),
        ),
        error: (e) => _ErrorView(
          message: e,
          onRetry: () => ref.read(taskVMProvider.notifier).loadTasks(),
        ),
        data: (tasks) {
          if (tasks.isEmpty) {
            return _EmptyView(onCreate: () => GoRouter.of(context).go('/create'));
          }
          return RefreshIndicator(
            color: theme.colorScheme.primary,
            onRefresh: () => ref.read(taskVMProvider.notifier).loadTasks(),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              itemCount: tasks.length,
              itemBuilder: (ctx, i) => _TaskCard(task: tasks[i]),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => GoRouter.of(context).go('/create'),
        icon: const Icon(Icons.add),
        label: const Text('New Task'),
      ),
    );
  }
}

class _TaskCard extends ConsumerWidget {
  final Task task;
  const _TaskCard({required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final disabled = onSurface.withOpacity(0.6);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.hardEdge,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => ref.read(taskVMProvider.notifier).toggleComplete(task),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 28, height: 28,
                decoration: BoxDecoration(
                  color: task.completed
                      ? theme.colorScheme.primary
                      : Colors.transparent,
                  border: Border.all(
                    color: task.completed ? theme.colorScheme.primary : disabled,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: task.completed
                    ? Icon(Icons.check, size: 20, color: theme.colorScheme.onPrimary)
                    : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                task.title,
                style: theme.textTheme.bodyLarge!.copyWith(
                  color: task.completed ? disabled : onSurface,
                  decoration:
                      task.completed ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              color: theme.colorScheme.error,
              onPressed: () async {
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Delete Task'),
                    content: Text('Delete "${task.title}"?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.error),
                        onPressed: () => Navigator.of(ctx).pop(true),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
                if (ok == true) {
                  ref.read(taskVMProvider.notifier).deleteTask(task.id);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  final VoidCallback onCreate;
  const _EmptyView({required this.onCreate});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.task_alt, size: 96, color: theme.colorScheme.onSurface.withOpacity(0.2)),
          const SizedBox(height: 24),
          Text('No tasks yet!', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text('Tap below to add your first task.', style: theme.textTheme.bodyMedium),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onCreate,
            icon: const Icon(Icons.add),
            label: const Text('Create Task'),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
          const SizedBox(height: 16),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
