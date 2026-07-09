import '../data/repositories/task_repository.dart';
import 'command_builder.dart';
import 'media_service.dart';

/// Orchestrates the local processing lifecycle for a task request.
///
/// Boundary:
/// - Controllers ask the runner to start/cancel/retry work.
/// - The runner coordinates command building, FFmpeg execution, and task records.
/// - It should emit task status through TaskRepository, not directly mutate UI state.
class TaskRunner {
  const TaskRunner({
    required this.mediaService,
    required this.taskRepository,
    required this.commandBuilder,
  });

  final MediaService mediaService;
  final TaskRepository taskRepository;
  final CommandBuilder commandBuilder;

  // TODO(mvp): Add start/cancel/retry APIs that create records, run FFmpeg,
  // persist progress, capture failures, and save App-internal result paths.
}
