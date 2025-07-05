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
    final theme     = Theme.of(context);
    final authState = ref.watch(authVMProvider);
    final taskState = ref.watch(taskVMProvider);

    // Greeting text
    String greeting = 'Your Tasks';
    if (authState is Success) {
      greeting = 'Hello, ${authState.user.firstName}';
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,

      // AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          greeting,
          style: theme.textTheme.headlineSmall!
              .copyWith(color: theme.colorScheme.onSurface),
        ),
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

      // Body
      body: taskState.when(
        idle:    ()    => const SizedBox.shrink(),
        loading: ()    => Center(
                            child: CircularProgressIndicator(
                              color: theme.colorScheme.primary,
                            ),
                          ),
        error:   (e)   => _ErrorView(
                            message: e,
                            onRetry: () => ref.refresh(taskVMProvider),
                          ),
        data:    (tasks) {
          if (tasks.isEmpty) {
            return _EmptyView(onCreate: () => context.go('/create'));
          }
          return RefreshIndicator(
            color: theme.colorScheme.primary,
            onRefresh: () => ref.read(taskVMProvider.notifier).loadTasks(),
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
              itemCount: tasks.length,
              itemBuilder: (ctx, i) => _TaskCard(task: tasks[i]),
            ),
          );
        },
      ),

      
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/create'),
        icon: const Icon(Icons.add),
        label: const Text('New Task'),
        backgroundColor: theme.colorScheme.secondaryContainer,
        foregroundColor: theme.colorScheme.onSecondaryContainer,
        elevation: 6,
        shape: const StadiumBorder(),
      ),
    );
  }
}

class _TaskCard extends ConsumerWidget {
  const _TaskCard({required this.task});
  final Task task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme     = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final disabled  = onSurface.withOpacity(0.6);
    final textColor = task.completed ? disabled : onSurface;

    return Card(
      color: theme.cardTheme.color ?? theme.colorScheme.surface,
      shape: theme.cardTheme.shape,
      elevation: theme.cardTheme.elevation,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Checkbox
            GestureDetector(
              onTap: () => ref.read(taskVMProvider.notifier).toggleComplete(task),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: task.completed
                      ? theme.colorScheme.primary
                      : Colors.transparent,
                  border: Border.all(
                    color: task.completed
                        ? theme.colorScheme.primary
                        : disabled,
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

            // Title
            Expanded(
              child: Text(
                task.title,
                style: theme.textTheme.bodyLarge!.copyWith(
                  color: textColor,
                  decoration: task.completed ? TextDecoration.lineThrough : null,
                ),
              ),
            ),

            // Delete
            IconButton(
              icon: const Icon(Icons.delete_outline),
              color: theme.colorScheme.error,
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: theme.colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    title: Text('Delete Task', style: theme.textTheme.titleMedium),
                    content: Text('Delete "${task.title}"?', style: theme.textTheme.bodyMedium),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: Text('Cancel', style: TextStyle(color: theme.colorScheme.primary)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.error),
                        onPressed: () => Navigator.of(ctx).pop(true),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
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
  const _EmptyView({required this.onCreate});
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.task_alt, size: 96, color: theme.colorScheme.onSurface.withOpacity(0.2)),
            const SizedBox(height: 24),
            Text('No tasks yet!', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Tap below to add your first task.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.add),
              label: const Text('Create Task'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: const StadiumBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
