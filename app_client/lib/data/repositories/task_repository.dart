import '../database/app_database.dart';

/// Isolates task-record persistence from UI and platform services.
///
/// Boundary:
/// - Controllers/runners call this repository for task history changes.
/// - Drift table details stay here instead of leaking into widgets.
/// - Records are a processing history and result locator, not a permanent backup.
class TaskRepository {
  const TaskRepository(this.database);

  final AppDatabase database;

  Stream<List<TaskRecord>> watchRecentTasks() {
    return database.select(database.taskRecords).watch();
  }

  // TODO(mvp): Add create/update progress/mark success/mark failure/cancel/delete.
  // TODO(mvp): Map Drift rows to domain task records with user-readable errors.
}
