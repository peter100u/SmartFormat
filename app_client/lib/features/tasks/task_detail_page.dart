import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../shared/models/task_models.dart';
import '../../shared/models/tool_models.dart';
import 'task_controller.dart';

class TaskDetailPage extends ConsumerWidget {
  const TaskDetailPage({required this.taskId, super.key});

  final String taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final taskAsync = ref.watch(taskRecordProvider(taskId));
    final controller = ref.read(taskListControllerProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.taskDetailTitle)),
      body: taskAsync.when(
        data: (task) {
          if (task == null) {
            return Center(child: Text(l10n.taskMissingMessage));
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(task.inputName, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              _DetailRow(
                label: l10n.taskStatusLabel,
                value: _statusLabel(l10n, task.status),
              ),
              const SizedBox(height: 8),
              _DetailRow(
                label: l10n.taskProgressLabel,
                value: '${task.progress}%',
              ),
              if ((task.inputPath ?? '').isNotEmpty) ...[
                const SizedBox(height: 8),
                _DetailRow(
                  label: l10n.taskInputPathLabel,
                  value: task.inputPath!,
                ),
              ],
              if ((task.outputPath ?? '').isNotEmpty) ...[
                const SizedBox(height: 8),
                _DetailRow(
                  label: l10n.taskOutputPathLabel,
                  value: task.outputPath!,
                ),
              ],
              if ((task.errorMessage ?? '').isNotEmpty) ...[
                const SizedBox(height: 8),
                _DetailRow(
                  label: l10n.taskErrorLabel,
                  value: task.errorMessage!,
                ),
              ],
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  if (_canCancel(task.status))
                    FilledButton(
                      onPressed: () async {
                        await controller.cancelTask(taskId);
                      },
                      child: Text(l10n.taskCancelAction),
                    ),
                  if (_canRetry(task))
                    FilledButton(
                      onPressed: () async {
                        await controller.retryTask(taskId);
                      },
                      child: Text(l10n.taskRetryAction),
                    ),
                  OutlinedButton(
                    onPressed: () async {
                      await controller.deleteTask(taskId);
                    },
                    child: Text(l10n.taskDeleteAction),
                  ),
                ],
              ),
            ],
          );
        },
        error: (_, _) => Center(child: Text(l10n.taskMissingMessage)),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
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

  bool _canRetry(TaskRecord task) {
    return (task.status == TaskStatus.failed ||
            task.status == TaskStatus.cancelled) &&
        (task.inputPath ?? '').isNotEmpty &&
        (task.outputPath ?? '').isNotEmpty;
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 2),
        Text(value),
      ],
    );
  }
}
