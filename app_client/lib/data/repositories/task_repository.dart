import 'package:hive_ce/hive_ce.dart';

import '../../shared/models/task_models.dart';

/// 将任务记录持久化与 UI、平台服务隔离开来。
///
/// 边界：
/// - controller 和 runner 通过这个 repository 处理任务历史变更。
/// - Hive box 细节应留在这里，不应泄漏到 widget 中。
/// - 这些记录用于处理历史和结果定位，不是永久备份。
class TaskRepository {
  const TaskRepository(this.box);

  final Box<TaskRecord> box;

  Stream<List<TaskRecord>> watchRecentTasks() async* {
    yield _sortedRecords();
    await for (final _ in box.watch()) {
      yield _sortedRecords();
    }
  }

  Future<void> saveTask(TaskRecord record) async {
    await box.put(record.id, record);
  }

  Future<void> deleteTask(String taskId) async {
    await box.delete(taskId);
  }

  List<TaskRecord> _sortedRecords() {
    final records = box.values.toList(growable: false);
    records.sort((left, right) => right.createdAt.compareTo(left.createdAt));
    return records;
  }
}
