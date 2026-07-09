import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 展示单个已完成任务的结果状态和主要操作。
///
/// 边界：
/// - 这个页面只负责渲染任务和结果状态。
/// - 打开、分享、重试等动作应转发给 controller 或 service。
/// - 它不应直接调用 `open_file`、`share_plus`，也不应直接读取持久化层记录。
import '../../l10n/app_localizations.dart';
import '../../shared/models/task_models.dart';
import '../../shared/models/tool_models.dart';
import '../tasks/task_controller.dart';

class TaskResultPage extends ConsumerWidget {
  const TaskResultPage({required this.taskId, super.key});

  final String taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final taskAsync = ref.watch(taskRecordProvider(taskId));
    final controller = ref.read(taskListControllerProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.taskResultTitle)),
      body: taskAsync.when(
        data: (task) {
          if (task == null) {
            return Center(child: Text(l10n.taskMissingMessage));
          }
          final hasOutput = (task.outputPath ?? '').isNotEmpty;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(task.inputName, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              Text(
                '${l10n.taskStatusLabel}: '
                '${_statusLabel(l10n, task.status)}',
              ),
              if ((task.outputPath ?? '').isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  '${l10n.taskOutputPathLabel}: '
                  '${task.outputPath!}',
                ),
              ],
              if ((task.errorMessage ?? '').isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  '${l10n.taskErrorLabel}: '
                  '${task.errorMessage!}',
                ),
              ],
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: hasOutput
                    ? () async {
                        await controller.openTaskResult(taskId);
                      }
                    : null,
                icon: const Icon(Icons.open_in_new),
                label: Text(l10n.taskOpenAction),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: hasOutput
                    ? () async {
                        await controller.shareTaskResult(taskId);
                      }
                    : null,
                icon: const Icon(Icons.ios_share),
                label: Text(l10n.taskShareAction),
              ),
              if (_canRetry(task)) ...[
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () async {
                    await controller.retryTask(taskId);
                  },
                  child: Text(l10n.taskRetryAction),
                ),
              ],
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

  bool _canRetry(TaskRecord task) {
    return (task.status == TaskStatus.failed ||
            task.status == TaskStatus.cancelled) &&
        (task.inputPath ?? '').isNotEmpty &&
        (task.outputPath ?? '').isNotEmpty;
  }
}
