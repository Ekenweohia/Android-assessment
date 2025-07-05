import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/viewmodels/task_viewmodels.dart';

class CreateTaskScreen extends ConsumerStatefulWidget {
  const CreateTaskScreen({super.key});
  @override
  ConsumerState<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends ConsumerState<CreateTaskScreen> {
  final _titleCtrl = TextEditingController();
  final _formKey   = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(taskVMProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('New Task')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              controller: _titleCtrl,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  v!.trim().isEmpty ? 'Please enter a title' : null,
            ),
            const SizedBox(height: 24),
            state.maybeWhen(
              loading: () => const Center(child: CircularProgressIndicator()),
              orElse: () => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;
                    await ref
                        .read(taskVMProvider.notifier)
                        .addTask(_titleCtrl.text.trim());
                    if (mounted) {
                      context.go('/tasks');
                    }
                  },
                  child: const Text('Create Task'),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
