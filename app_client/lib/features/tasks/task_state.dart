import '../../shared/models/task_models.dart';

class TaskListState {
  const TaskListState({this.tasks = const []});

  final List<TaskRecord> tasks;
}
