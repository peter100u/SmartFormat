import 'package:flutter/material.dart';

class TaskDetailPage extends StatelessWidget {
  const TaskDetailPage({required this.taskId, super.key});

  final String taskId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('任务详情')),
      body: Center(child: Text('任务 ID：$taskId')),
    );
  }
}
