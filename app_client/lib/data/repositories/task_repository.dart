import 'package:hive_ce/hive_ce.dart';
import 'package:logger/logger.dart';

import '../../core/logging/app_logger.dart';
import '../../shared/models/task_models.dart';

/// 将任务记录持久化与 UI、平台服务隔离开来。
///
/// 边界：
/// - controller 和 runner 通过这个 repository 处理任务历史变更。
/// - Hive box 细节应留在这里，不应泄漏到 widget 中。
/// - 这些记录用于处理历史和结果定位，不是永久备份。
class TaskRepository {
  TaskRepository(this.box, {Logger? logger}) : _logger = logger ?? appLogger;

  final Box<TaskRecord> box;
  final Logger _logger;

  Stream<List<TaskRecord>> watchRecentTasks() async* {
    final initialSnapshot = _sortedRecords();
    _logger.t('taskRepository.snapshot count=${initialSnapshot.length}');
    yield initialSnapshot;
    await for (final event in box.watch()) {
      final snapshot = _sortedRecords();
      _logger.t(
        'taskRepository.snapshot key=${event.key} deleted=${event.deleted} '
        'count=${snapshot.length}',
      );
      yield snapshot;
    }
  }

  Stream<TaskRecord?> watchTask(String taskId) async* {
    yield getTask(taskId);
    await for (final event in box.watch(key: taskId)) {
      yield event.deleted ? null : event.value as TaskRecord?;
    }
  }

  TaskRecord? getTask(String taskId) {
    return box.get(taskId);
  }

  TaskRecord? loadTask(String taskId) {
    return getTask(taskId);
  }

  Future<void> saveTask(TaskRecord record) async {
    _logger.d(
      'taskRepository.save taskId=${record.id} status=${record.status.name} '
      'progress=${record.progress}',
    );
    await box.put(record.id, record);
  }

  Future<void> saveTasks(Iterable<TaskRecord> records) async {
    for (final record in records) {
      await saveTask(record);
    }
  }

  Future<void> deleteTask(String taskId) async {
    _logger.w('taskRepository.delete taskId=$taskId');
    await box.delete(taskId);
  }

  List<TaskRecord> _sortedRecords() {
    final records = box.values.toList(growable: false);
    records.sort((left, right) => right.createdAt.compareTo(left.createdAt));
    return records;
  }
}
