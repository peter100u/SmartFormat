import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'task_state.dart';

final taskListControllerProvider =
    NotifierProvider<TaskListController, TaskListState>(TaskListController.new);

/// Owns task-list UI state and task record actions.
///
/// Boundary:
/// - TasksPage watches this state and forwards user actions here.
/// - Repository reads/writes and runner retry/cancel calls belong behind this controller.
/// - Widgets should not directly mutate Drift rows or platform task execution.
class TaskListController extends Notifier<TaskListState> {
  @override
  TaskListState build() {
    return const TaskListState();
  }

  Future<void> cancelTask(String taskId) async {
    // TODO(mvp): Cancel active FFmpeg work and persist TaskStatus.cancelled.
  }

  Future<void> retryTask(String taskId) async {
    // TODO(mvp): Recreate the original TaskRequest and enqueue it through TaskRunner.
  }

  Future<void> deleteTask(String taskId) async {
    // TODO(mvp): Delete the task record and decide whether to remove result files.
  }
}
