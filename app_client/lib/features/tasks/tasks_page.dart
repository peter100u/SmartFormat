import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/models/tool_models.dart';
import 'task_controller.dart';

class TasksPage extends ConsumerWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(taskListControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tasksTitle)),
      body: state.tasks.isEmpty
          ? const EmptyTasksView()
          : ListView.builder(
              itemCount: state.tasks.length,
              itemBuilder: (context, index) {
                final task = state.tasks[index];
                return ListTile(
                  onTap: () {
                    final routeName = task.status == TaskStatus.succeeded
                        ? AppRoutes.taskResult
                        : AppRoutes.taskDetail;
                    context.pushNamed(
                      routeName,
                      pathParameters: {'taskId': task.id},
                    );
                  },
                  leading: Icon(_statusIcon(task.status)),
                  title: Text(task.inputName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_statusLabel(l10n, task.status)),
                      if ((task.errorMessage ?? '').isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          task.errorMessage!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (_canCancel(task.status))
                            OutlinedButton(
                              onPressed: () async {
                                await ref
                                    .read(taskListControllerProvider.notifier)
                                    .cancelTask(task.id);
                              },
                              child: Text(l10n.taskCancelAction),
                            ),
                          if (_canRetry(task.status))
                            OutlinedButton(
                              onPressed: () async {
                                await ref
                                    .read(taskListControllerProvider.notifier)
                                    .retryTask(task.id);
                              },
                              child: Text(l10n.taskRetryAction),
                            ),
                          OutlinedButton(
                            onPressed: () async {
                              await ref
                                  .read(taskListControllerProvider.notifier)
                                  .deleteTask(task.id);
                            },
                            child: Text(l10n.taskDeleteAction),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Text('${task.progress}%'),
                );
              },
            ),
    );
  }

  IconData _statusIcon(TaskStatus status) {
    return switch (status) {
      TaskStatus.queued => Icons.schedule_outlined,
      TaskStatus.running => Icons.sync,
      TaskStatus.succeeded => Icons.check_circle_outline,
      TaskStatus.failed => Icons.error_outline,
      TaskStatus.cancelled => Icons.block_outlined,
    };
  }

  String _statusLabel(AppLocalizations l10n, TaskStatus status) {
    return switch (status) {
      TaskStatus.queued => l10n.taskStatusQueued,
      TaskStatus.running => l10n.taskStatusRunning,
      TaskStatus.succeeded => l10n.taskStatusSucceeded,
      TaskStatus.failed => l10n.taskStatusFailed,
      TaskStatus.cancelled => l10n.taskStatusCancelled,
    };
  }

  bool _canCancel(TaskStatus status) {
    return status == TaskStatus.queued || status == TaskStatus.running;
  }

  bool _canRetry(TaskStatus status) {
    return status == TaskStatus.failed || status == TaskStatus.cancelled;
  }
}

class EmptyTasksView extends StatelessWidget {
  const EmptyTasksView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
            Text(
              l10n.tasksEmptyTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(l10n.tasksEmptyMessage),
          ],
        ),
      ),
    );
  }
}
