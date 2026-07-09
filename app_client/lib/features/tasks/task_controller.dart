import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;

import '../../shared/models/media_file.dart';
import '../../shared/models/task_models.dart';
import '../../shared/models/tool_models.dart';
import '../../shared/providers/repository_providers.dart';
import '../../shared/providers/service_providers.dart';
import '../../shared/providers/tool_providers.dart';
import 'task_state.dart';

final taskListControllerProvider =
    NotifierProvider<TaskListController, TaskListState>(TaskListController.new);
final taskRecordProvider = StreamProvider.family<TaskRecord?, String>((
  ref,
  taskId,
) {
  return ref.watch(taskRepositoryProvider).watchTask(taskId);
});

/// 负责任务列表的 UI 状态和任务记录操作。
///
/// 边界：
/// - `TasksPage` 监听这里的状态，并把用户操作转发到这里。
/// - repository 的读写以及 runner 的重试、取消调用都应收敛在这个 controller 后面。
/// - Widget 不应直接修改持久化记录，也不应直接触发平台任务执行。
class TaskListController extends Notifier<TaskListState> {
  @override
  TaskListState build() {
    final subscription = ref
        .watch(taskRepositoryProvider)
        .watchRecentTasks()
        .listen(_updateTasks);
    ref.onDispose(subscription.cancel);
    return const TaskListState();
  }

  void _updateTasks(List tasks) {
    state = TaskListState(tasks: tasks.cast());
  }

  Future<bool> cancelTask(String taskId) async {
    final repository = ref.read(taskRepositoryProvider);
    final record = repository.loadTask(taskId);
    if (record == null) {
      return false;
    }

    await ref.read(taskRunnerProvider).cancelTask(taskId);
    await repository.saveTask(
      _copyRecord(
        record,
        status: TaskStatus.cancelled,
        errorCode: TaskErrorCode.cancelled.name,
        errorMessage: null,
        logSummary: record.logSummary,
        completedAt: DateTime.now(),
      ),
    );
    return true;
  }

  Future<bool> retryTask(String taskId) async {
    final repository = ref.read(taskRepositoryProvider);
    final record = repository.loadTask(taskId);
    if (record == null || record.inputPath == null || record.outputPath == null) {
      return false;
    }

    final tool = ref.read(toolRegistryProvider).requireById(record.toolId);
    final extension = path.extension(record.outputPath!).replaceFirst('.', '');
    final preset = tool.presets.firstWhere(
      (item) => item.outputExtension == extension,
      orElse: () => tool.presets.first,
    );
    final request = TaskRequest(
      id: record.id,
      toolId: record.toolId,
      input: MediaFile(
        id: record.id,
        displayName: record.inputName,
        path: record.inputPath,
        kind: tool.category,
        source: InputSource.filePicker,
      ),
      presetId: preset.id,
      outputTarget: OutputTarget.appResult,
      outputPath: record.outputPath!,
      parameters: preset.parameters,
      createdAt: DateTime.now(),
    );
    await ref.read(taskRunnerProvider).startTask(request);
    return true;
  }

  Future<bool> deleteTask(String taskId) async {
    final repository = ref.read(taskRepositoryProvider);
    final record = repository.loadTask(taskId);
    if (record == null) {
      return false;
    }

    if (record.outputPath != null) {
      final outputFile = File(record.outputPath!);
      if (await outputFile.exists()) {
        await outputFile.delete();
      }
    }
    await repository.deleteTask(taskId);
    return true;
  }

  Future<bool> openTaskResult(String taskId) async {
    final record = ref.read(taskRepositoryProvider).loadTask(taskId);
    final outputPath = record?.outputPath;
    if (outputPath == null || outputPath.isEmpty) {
      return false;
    }
    await ref.read(openFileServiceProvider).open(outputPath);
    return true;
  }

  Future<bool> shareTaskResult(String taskId) async {
    final record = ref.read(taskRepositoryProvider).loadTask(taskId);
    final outputPath = record?.outputPath;
    if (outputPath == null || outputPath.isEmpty) {
      return false;
    }
    await ref.read(shareServiceProvider).shareFile(outputPath);
    return true;
  }

  TaskRecord _copyRecord(
    TaskRecord record, {
    required TaskStatus status,
    String? errorCode,
    String? errorMessage,
    String? logSummary,
    DateTime? completedAt,
  }) {
    return TaskRecord(
      id: record.id,
      toolId: record.toolId,
      status: status,
      progress: status == TaskStatus.succeeded ? 100 : record.progress,
      inputName: record.inputName,
      inputPath: record.inputPath,
      outputPath: record.outputPath,
      outputMimeType: record.outputMimeType,
      outputSizeBytes: record.outputSizeBytes,
      errorCode: errorCode,
      errorMessage: errorMessage,
      ffmpegReturnCode: record.ffmpegReturnCode,
      logSummary: logSummary,
      createdAt: record.createdAt,
      startedAt: record.startedAt,
      completedAt: completedAt,
    );
  }
}
