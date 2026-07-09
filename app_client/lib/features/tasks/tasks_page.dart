import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'task_controller.dart';

class TasksPage extends ConsumerWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(taskListControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('任务')),
      body: state.tasks.isEmpty
          ? const EmptyTasksView()
          : ListView.builder(
              itemCount: state.tasks.length,
              itemBuilder: (context, index) {
                final task = state.tasks[index];
                return ListTile(
                  title: Text(task.inputName),
                  subtitle: Text(task.status.name),
                  trailing: Text('${task.progress}%'),
                );
              },
            ),
    );
  }
}

class EmptyTasksView extends StatelessWidget {
  const EmptyTasksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.task_alt,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text('还没有任务', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            const Text('完成转换后，处理记录会显示在这里。'),
          ],
        ),
      ),
    );
  }
}
