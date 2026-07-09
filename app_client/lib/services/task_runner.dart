import '../data/repositories/task_repository.dart';
import 'command_builder.dart';
import 'media_service.dart';

/// 编排一次任务请求的本地处理生命周期。
///
/// 边界：
/// - controller 通过 runner 发起开始、取消、重试等动作。
/// - runner 负责协调命令构建、FFmpeg 执行和任务记录。
/// - 它应通过 `TaskRepository` 输出任务状态，而不是直接修改 UI 状态。
class TaskRunner {
  const TaskRunner({
    required this.mediaService,
    required this.taskRepository,
    required this.commandBuilder,
  });

  final MediaService mediaService;
  final TaskRepository taskRepository;
  final CommandBuilder commandBuilder;

  // TODO(mvp): 增加开始、取消、重试等 API，用于创建记录、执行 FFmpeg、
  // 持久化进度、捕获失败信息，并保存应用内部结果路径。
}
