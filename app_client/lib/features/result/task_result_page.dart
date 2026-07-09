import 'package:flutter/material.dart';

/// Shows the output state and primary actions for one completed task.
///
/// Boundary:
/// - This page should render task/result state only.
/// - Open/share/retry actions should be forwarded to controllers/services.
/// - It must not call open_file/share_plus or read Drift rows directly.
class TaskResultPage extends StatelessWidget {
  const TaskResultPage({required this.taskId, super.key});

  final String taskId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('结果')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('任务 ID：$taskId'),
          const SizedBox(height: 16),
          FilledButton.icon(
            // TODO(mvp): Enable after loading the task output path and call OpenFileService.
            onPressed: null,
            icon: const Icon(Icons.open_in_new),
            label: const Text('打开'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            // TODO(mvp): Enable after loading the task output path and call ShareService.
            onPressed: null,
            icon: const Icon(Icons.ios_share),
            label: const Text('分享'),
          ),
        ],
      ),
    );
  }
}
