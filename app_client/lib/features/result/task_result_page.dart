import 'package:flutter/material.dart';

/// 展示单个已完成任务的结果状态和主要操作。
///
/// 边界：
/// - 这个页面只负责渲染任务和结果状态。
/// - 打开、分享、重试等动作应转发给 controller 或 service。
/// - 它不应直接调用 `open_file`、`share_plus`，也不应直接读取持久化层记录。
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
            // TODO(mvp): 加载任务输出路径后启用，并调用 `OpenFileService`。
            onPressed: null,
            icon: const Icon(Icons.open_in_new),
            label: const Text('打开'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            // TODO(mvp): 加载任务输出路径后启用，并调用 `ShareService`。
            onPressed: null,
            icon: const Icon(Icons.ios_share),
            label: const Text('分享'),
          ),
        ],
      ),
    );
  }
}
