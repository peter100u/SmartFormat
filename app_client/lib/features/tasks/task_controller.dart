import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'task_state.dart';

final taskListControllerProvider =
    NotifierProvider<TaskListController, TaskListState>(TaskListController.new);

/// 负责任务列表的 UI 状态和任务记录操作。
///
/// 边界：
/// - `TasksPage` 监听这里的状态，并把用户操作转发到这里。
/// - repository 的读写以及 runner 的重试、取消调用都应收敛在这个 controller 后面。
/// - Widget 不应直接修改持久化记录，也不应直接触发平台任务执行。
class TaskListController extends Notifier<TaskListState> {
  @override
  TaskListState build() {
    return const TaskListState();
  }

  Future<void> cancelTask(String taskId) async {
    // TODO(mvp): 取消正在执行的 FFmpeg 任务，并持久化 `TaskStatus.cancelled`。
  }

  Future<void> retryTask(String taskId) async {
    // TODO(mvp): 重建原始 `TaskRequest`，并通过 `TaskRunner` 重新入队执行。
  }

  Future<void> deleteTask(String taskId) async {
    // TODO(mvp): 删除任务记录，并决定是否一并移除结果文件。
  }
}
